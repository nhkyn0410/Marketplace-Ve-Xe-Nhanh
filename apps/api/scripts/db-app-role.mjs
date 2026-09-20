// Tạo / cập nhật role Postgres cho app (TASK-IAM-003, quyết định Q3). Idempotent.
//
// Vì sao cần: superuser, role BYPASSRLS và owner bảng (hoặc thành viên role owner) đều vượt được RLS
// (DB-PRIN-01). App chạy bằng role đó thì mọi policy RLS chỉ là trang trí, và test RLS xanh giả.
//
// - `MIGRATION_DATABASE_URL`: owner — dùng để chạy script này, migrate, seed.
// - `DATABASE_URL`: role app — tên + mật khẩu lấy từ chính URL này, script tạo đúng role đó.
//
// Supabase Shared Pooler dùng username định tuyến `<role>.<project-ref>`. Script giữ nguyên username
// đó khi kết nối, nhưng chỉ dùng phần `<role>` làm Postgres role trong câu lệnh SQL.
//
// THỨ TỰ: `prisma migrate deploy` TRƯỚC, script này SAU (script từ chối chạy nếu chưa migrate — nếu
// không, bảng `_prisma_migrations` tạo sau sẽ thừa hưởng quyền CRUD mặc định cho role app).
//
// Dùng:
// - Provision: pnpm --filter @vexenhanh/api db:app-role
// - Cleanup role pooler tạo nhầm bởi bản script cũ: pnpm --filter @vexenhanh/api db:app-role:cleanup
import { createHash, createHmac, pbkdf2Sync, randomBytes } from "node:crypto";
import { existsSync } from "node:fs";
import { createRequire } from "node:module";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const { Client } = require("pg");
const apiRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const CLEANUP_FLAG = "--cleanup-legacy-pooler-role";
const SUPABASE_POOLER_HOST_SUFFIX = ".pooler.supabase.com";
const SUPABASE_PROJECT_REF_PATTERN = /^[a-z0-9]{20}$/;
const POOLER_AUTH_RETRY_DELAYS_MS = [0, 1_000, 2_000, 4_000, 8_000];

function loadEnv() {
  // Cùng cơ chế env với app/prisma.config: `.env` rồi `.env.{NODE_ENV}`; biến có sẵn thì giữ nguyên.
  const nodeEnv = process.env.NODE_ENV?.trim() || "development";
  for (const file of [".env", `.env.${nodeEnv}`]) {
    const path = resolve(apiRoot, file);
    if (existsSync(path)) {
      process.loadEnvFile(path);
    }
  }
}

function requireUrl(key) {
  const value = process.env[key]?.trim();
  if (!value) {
    throw new Error(`${key} chưa set — xem apps/api/.env.example.`);
  }
  return parseDatabaseUrl(value, key);
}

export function parseDatabaseUrl(value, key) {
  let url;
  try {
    url = new URL(value);
  } catch {
    // Không nối lỗi gốc: ERR_INVALID_URL có thể chứa toàn bộ URL, bao gồm password.
    throw new Error(`${key} không phải PostgreSQL URL hợp lệ.`);
  }
  if (url.protocol !== "postgres:" && url.protocol !== "postgresql:") {
    throw new Error(`${key} phải dùng giao thức postgresql:// hoặc postgres://.`);
  }
  return url;
}

function decodeUsername(url, key) {
  try {
    return decodeURIComponent(url.username);
  } catch {
    throw new Error(`${key} có username URL-encoded không hợp lệ.`);
  }
}

function decodePassword(url, key) {
  try {
    const password = decodeURIComponent(url.password);
    if (!password) {
      throw new Error(`${key} phải có password.`);
    }
    return password;
  } catch (error) {
    if (error instanceof URIError) {
      throw new Error(`${key} có password URL-encoded không hợp lệ.`);
    }
    throw error;
  }
}

export function parseRoleIdentity(url, key) {
  const connectionRole = decodeUsername(url, key);
  if (!connectionRole) {
    throw new Error(`${key} phải có username.`);
  }

  const isSupabasePooler = url.hostname.toLowerCase().endsWith(SUPABASE_POOLER_HOST_SUFFIX);
  if (!isSupabasePooler) {
    return { connectionRole, sqlRole: connectionRole, projectRef: undefined, isSupabasePooler };
  }

  if ((url.port || "5432") !== "5432") {
    throw new Error(`${key} phải dùng Supabase Session Pooler cổng 5432 cho tác vụ role.`);
  }
  const sslModes = url.searchParams.getAll("sslmode");
  if (sslModes.length !== 1 || sslModes[0] !== "verify-full") {
    throw new Error(`${key} dùng Supabase pooler phải có sslmode=verify-full.`);
  }

  const separator = connectionRole.lastIndexOf(".");
  const sqlRole = connectionRole.slice(0, separator);
  const projectRef = connectionRole.slice(separator + 1);
  if (separator <= 0 || !SUPABASE_PROJECT_REF_PATTERN.test(projectRef)) {
    throw new Error(
      `${key} dùng Supabase pooler nên username phải có dạng <role>.<PROJECT_REF> ` +
        "(PROJECT_REF gồm 20 ký tự chữ thường/số)."
    );
  }

  return { connectionRole, sqlRole, projectRef, isSupabasePooler };
}

export function resolveRoleIdentities(ownerUrl, appUrl) {
  const owner = parseRoleIdentity(ownerUrl, "MIGRATION_DATABASE_URL");
  const app = parseRoleIdentity(appUrl, "DATABASE_URL");

  if (owner.isSupabasePooler !== app.isSupabasePooler) {
    throw new Error("DATABASE_URL và MIGRATION_DATABASE_URL không được trộn direct với Supabase pooler.");
  }
  if (owner.isSupabasePooler && owner.projectRef !== app.projectRef) {
    throw new Error("DATABASE_URL và MIGRATION_DATABASE_URL phải dùng cùng Supabase PROJECT_REF.");
  }
  if (owner.sqlRole === app.sqlRole) {
    throw new Error(
      `DATABASE_URL và MIGRATION_DATABASE_URL cùng Postgres role "${app.sqlRole}". ` +
        "App phải chạy bằng role RIÊNG, không phải owner — nếu không RLS không có tác dụng."
    );
  }

  return { owner, app };
}

export function validateRolePasswords(ownerUrl, appUrl, { requireStrongAppPassword = false } = {}) {
  const ownerPassword = decodePassword(ownerUrl, "MIGRATION_DATABASE_URL");
  const appPassword = decodePassword(appUrl, "DATABASE_URL");
  if (ownerPassword.normalize("NFKC") === appPassword.normalize("NFKC")) {
    throw new Error(
      "DATABASE_URL phải dùng mật khẩu riêng cho role app, không được trùng mật khẩu owner."
    );
  }
  if (requireStrongAppPassword && !/^[\x21-\x7e]{32,}$/.test(appPassword)) {
    throw new Error(
      "DATABASE_URL trên Supabase phải dùng mật khẩu app ngẫu nhiên gồm ít nhất 32 ký tự ASCII in được, không có khoảng trắng."
    );
  }
  return { appPassword };
}

/**
 * Gửi verifier SCRAM-SHA-256 thay vì mật khẩu thô: câu `CREATE/ALTER ROLE ... PASSWORD` có thể nằm
 * trong log server (log_statement = ddl) — verifier thì không dùng lại được để đăng nhập.
 * (SASLprep đơn giản hoá bằng NFKC — đủ cho mật khẩu ASCII sinh ngẫu nhiên.)
 */
function scramVerifier(password) {
  const iterations = 4096;
  const salt = randomBytes(16);
  const salted = pbkdf2Sync(password.normalize("NFKC"), salt, iterations, 32, "sha256");
  const clientKey = createHmac("sha256", salted).update("Client Key").digest();
  const storedKey = createHash("sha256").update(clientKey).digest();
  const serverKey = createHmac("sha256", salted).update("Server Key").digest();
  return `SCRAM-SHA-256$${iterations}:${salt.toString("base64")}$${storedKey.toString("base64")}:${serverKey.toString("base64")}`;
}

export async function provisionAppRole(client, { appRole, appPassword, ownerRole, database, schema }) {
  const role = client.escapeIdentifier(appRole);
  const owner = client.escapeIdentifier(ownerRole);
  const db = client.escapeIdentifier(database);
  const ns = client.escapeIdentifier(schema);
  const password = client.escapeLiteral(scramVerifier(appPassword));

  await client.query("BEGIN");
  try {
    const { rowCount: migrated } = await client.query(
      "select 1 from information_schema.tables where table_schema = $1 and table_name = '_prisma_migrations'",
      [schema]
    );
    if (!migrated) {
      throw new Error("Chưa có bảng _prisma_migrations — chạy `prisma migrate deploy` (bằng owner) TRƯỚC script này.");
    }

    const { rowCount: exists } = await client.query("select 1 from pg_roles where rolname = $1", [appRole]);
    if (exists === 0) {
      await client.query(
        `CREATE ROLE ${role} LOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION PASSWORD ${password}`
      );
    } else {
      // Role đã có: CHỈ đổi mật khẩu. ALTER thuộc tính (NOSUPERUSER...) bị Postgres managed từ chối khi
      // owner không phải superuser — thuộc tính sai sẽ bị phát hiện ở bước kiểm cuối và báo to.
      await client.query(`ALTER ROLE ${role} PASSWORD ${password}`);
    }
    // Tham số mặc định gắn vào role (vd `app.scope = system`) sẽ biến "không ngữ cảnh" từ 0 row thành
    // thấy hết — xoá sạch, cả mức database.
    await client.query(`ALTER ROLE ${role} RESET ALL`);
    await client.query(`ALTER ROLE ${role} IN DATABASE ${db} RESET ALL`);

    const statements = [
      // Thu hồi grant trực tiếp còn sót từ lần cấu hình trước, rồi cấp lại đúng allowlist. REVOKE không
      // xoá quyền thừa hưởng qua PUBLIC/role khác, nên bước kiểm hiệu lực phía dưới vẫn là bắt buộc.
      `REVOKE ALL PRIVILEGES ON DATABASE ${db} FROM ${role}`,
      `REVOKE ALL PRIVILEGES ON SCHEMA ${ns} FROM ${role}`,
      `REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ${ns} FROM ${role}`,
      `REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA ${ns} FROM ${role}`,
      `ALTER DEFAULT PRIVILEGES FOR ROLE ${owner} IN SCHEMA ${ns} REVOKE ALL PRIVILEGES ON TABLES FROM ${role}`,
      `ALTER DEFAULT PRIVILEGES FOR ROLE ${owner} IN SCHEMA ${ns} REVOKE ALL PRIVILEGES ON SEQUENCES FROM ${role}`,
      `GRANT CONNECT ON DATABASE ${db} TO ${role}`,
      `GRANT USAGE ON SCHEMA ${ns} TO ${role}`,
      `GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${ns} TO ${role}`,
      `GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA ${ns} TO ${role}`,
      // Bảng do owner tạo ở migration SAU này tự có quyền — khỏi phải nhớ chạy lại script.
      `ALTER DEFAULT PRIVILEGES FOR ROLE ${owner} IN SCHEMA ${ns} GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${role}`,
      `ALTER DEFAULT PRIVILEGES FOR ROLE ${owner} IN SCHEMA ${ns} GRANT USAGE, SELECT ON SEQUENCES TO ${role}`,
      // Lịch sử migrate không phải việc của app (sửa được nó là chặn/lặp được deploy).
      `REVOKE ALL ON TABLE ${ns}."_prisma_migrations" FROM ${role}`
    ];
    for (const sql of statements) {
      await client.query(sql);
    }

    const { rows } = await client.query(
      `select r.rolsuper, r.rolbypassrls, r.rolcreaterole, r.rolcreatedb, r.rolreplication,
              r.rolconfig,
              exists (
                select 1 from pg_auth_members m where m.member = r.oid
              ) as is_member_of_other_role,
              exists (
                select 1
                  from pg_auth_members m
                  join pg_roles member_role on member_role.oid = m.member
                 where m.roleid = r.oid
                   and member_role.rolname <> $3
              ) as has_unexpected_members,
              exists (
                select 1
                  from pg_shdepend d
                 where d.refclassid = 'pg_authid'::regclass
                   and d.refobjid = r.oid
                   and d.deptype = 'o'
              ) as owns_objects,
              exists (
                select 1
                  from pg_class c
                  join pg_namespace n on n.oid = c.relnamespace
                 where n.nspname = $2
                   and case when c.relkind in ('r', 'p') then
                     has_table_privilege(r.rolname, c.oid, 'TRUNCATE')
                     or has_table_privilege(r.rolname, c.oid, 'REFERENCES')
                     or has_table_privilege(r.rolname, c.oid, 'TRIGGER')
                   else false end
              ) as has_extra_table_privileges,
              exists (
                select 1
                  from pg_class c
                  join pg_namespace n on n.oid = c.relnamespace
                 where n.nspname = $2
                   and case when c.relkind = 'S' then
                     has_sequence_privilege(r.rolname, c.oid, 'UPDATE')
                   else false end
              ) as has_extra_sequence_privileges,
              exists (
                select 1
                  from pg_namespace n
                 where n.nspname = $2
                   and has_schema_privilege(r.rolname, n.oid, 'CREATE')
              ) as can_create_in_schema
         from pg_roles r where r.rolname = $1`,
      [appRole, schema, ownerRole]
    );
    const [state] = rows;
    if (!state) {
      throw new Error(`Không đọc được trạng thái role app "${appRole}" sau khi tạo.`);
    }
    const problems = [
      state.rolsuper && "SUPERUSER",
      state.rolbypassrls && "BYPASSRLS",
      state.rolcreaterole && "CREATEROLE",
      state.rolcreatedb && "CREATEDB",
      state.rolreplication && "REPLICATION",
      state.rolconfig && "có tham số mặc định",
      state.is_member_of_other_role && "là thành viên của role khác",
      state.has_unexpected_members && `có member không phải owner "${ownerRole}"`,
      state.owns_objects && "đang sở hữu object",
      state.has_extra_table_privileges && "có quyền bảng ngoài CRUD (TRUNCATE/REFERENCES/TRIGGER)",
      state.has_extra_sequence_privileges && "có quyền UPDATE sequence",
      state.can_create_in_schema && `có quyền CREATE trong schema "${schema}"`
    ].filter(Boolean);
    if (problems.length > 0) {
      throw new Error(
        `Role "${appRole}" vẫn vượt được RLS: ${problems.join(", ")}. Sửa bằng superuser rồi chạy lại script.`
      );
    }

    await client.query("COMMIT");
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  }
}

export async function cleanupLegacyPoolerRole(client, { appIdentity, database, schema }) {
  const candidate = appIdentity.connectionRole;
  const expectedCandidate = appIdentity.projectRef
    ? `${appIdentity.sqlRole}.${appIdentity.projectRef}`
    : undefined;
  if (!appIdentity.isSupabasePooler || !expectedCandidate || candidate !== expectedCandidate) {
    throw new Error("Cleanup chỉ áp dụng cho role định tuyến suy ra từ Supabase pooler URL hiện tại.");
  }

  const { rows } = await client.query(
    `select r.rolsuper, r.rolbypassrls, r.rolcreaterole, r.rolcreatedb, r.rolreplication,
            r.rolconfig,
            r.rolname = current_user as is_current,
            exists (
              select 1 from pg_auth_members m where m.member = r.oid
            ) as is_member_of_other_role,
            exists (
              select 1
                from pg_auth_members m
                join pg_roles member_role on member_role.oid = m.member
               where m.roleid = r.oid
                 and member_role.rolname <> current_user
            ) as has_unexpected_members,
            exists (
              select 1
                from pg_shdepend d
               where d.refclassid = 'pg_authid'::regclass
                 and d.refobjid = r.oid
                 and d.deptype = 'o'
            ) as owns_objects
       from pg_roles r
      where r.rolname = $1`,
    [candidate]
  );
  const [state] = rows;
  if (!state) {
    return { status: "absent", role: candidate };
  }

  const problems = [
    state.is_current && "đang là current_user",
    state.rolsuper && "SUPERUSER",
    state.rolbypassrls && "BYPASSRLS",
    state.rolcreaterole && "CREATEROLE",
    state.rolcreatedb && "CREATEDB",
    state.rolreplication && "REPLICATION",
    state.rolconfig && "có tham số mặc định",
    state.is_member_of_other_role && "là thành viên của role khác",
    state.has_unexpected_members && "có member không phải current_user",
    state.owns_objects && "đang sở hữu object"
  ].filter(Boolean);
  if (problems.length > 0) {
    throw new Error(`Từ chối cleanup role "${candidate}": ${problems.join(", ")}.`);
  }

  const role = client.escapeIdentifier(candidate);
  const db = client.escapeIdentifier(database);
  const ns = client.escapeIdentifier(schema);
  const statements = [
    `REVOKE CONNECT ON DATABASE ${db} FROM ${role}`,
    `REVOKE USAGE ON SCHEMA ${ns} FROM ${role}`,
    `REVOKE SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${ns} FROM ${role}`,
    `REVOKE USAGE, SELECT ON ALL SEQUENCES IN SCHEMA ${ns} FROM ${role}`,
    // Không dùng DROP OWNED/REASSIGN OWNED: DROP ROLE phải tự từ chối nếu còn dependency ngoài dự kiến.
    `DROP ROLE ${role}`
  ];

  await client.query("BEGIN");
  try {
    for (const sql of statements) {
      await client.query(sql);
    }
    await client.query("COMMIT");
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  }

  return { status: "removed", role: candidate };
}

function isTransientPoolerAuthError(error) {
  if (!(error instanceof Error)) return false;
  const code = "code" in error ? String(error.code) : "";
  return (
    code === "28P01" ||
    /EAUTHQUERY|password authentication failed|user not found in the database/i.test(error.message)
  );
}

function wait(milliseconds) {
  return new Promise((resolvePromise) => setTimeout(resolvePromise, milliseconds));
}

export async function verifyAppConnection({
  createClient,
  expectedRole,
  retryPoolerAuth = false,
  sleep = wait,
  onRetry = (message) => console.warn(message)
}) {
  const delays = retryPoolerAuth ? POOLER_AUTH_RETRY_DELAYS_MS : [0];
  for (let attempt = 0; attempt < delays.length; attempt += 1) {
    const delay = delays[attempt];
    if (delay > 0) await sleep(delay);

    const client = createClient();
    let failure;
    try {
      await client.connect();
      const { rows } = await client.query("select current_user as database_role");
      const connectedRole = rows[0]?.database_role;
      if (connectedRole !== expectedRole) {
        throw new Error(
          `DATABASE_URL định tuyến tới role "${connectedRole ?? "<unknown>"}", ` +
            `không phải role app mong đợi "${expectedRole}".`
        );
      }
    } catch (error) {
      failure = error;
    } finally {
      try {
        await client.end();
      } catch (error) {
        if (!failure) failure = error;
      }
    }

    if (!failure) return;
    const hasNextAttempt = attempt + 1 < delays.length;
    if (!hasNextAttempt || !retryPoolerAuth || !isTransientPoolerAuthError(failure)) {
      throw failure;
    }
    onRetry(
      `Supabase pooler chưa nhận credential mới; thử lại ${attempt + 2}/${delays.length} ` +
        `sau ${delays[attempt + 1]}ms.`
    );
  }
}

export async function runAppRole({
  ownerUrl,
  appUrl,
  cleanupRequested = false,
  createClient = (connectionString) => new Client({ connectionString }),
  sleep
}) {
  const { owner: ownerIdentity, app: appIdentity } = resolveRoleIdentities(ownerUrl, appUrl);
  const appRole = appIdentity.sqlRole;
  const ownerRole = ownerIdentity.sqlRole;
  const { appPassword } = validateRolePasswords(ownerUrl, appUrl, {
    requireStrongAppPassword: appIdentity.isSupabasePooler
  });
  const database = appUrl.pathname.replace(/^\//, "");
  const schema = appUrl.searchParams.get("schema") || "public";

  // Cấp quyền trên DB/schema của URL owner mà app lại trỏ chỗ khác = cấp nhầm chỗ, app vẫn không chạy.
  const sameTarget =
    appUrl.hostname === ownerUrl.hostname &&
    (appUrl.port || "5432") === (ownerUrl.port || "5432") &&
    database === ownerUrl.pathname.replace(/^\//, "") &&
    schema === (ownerUrl.searchParams.get("schema") || "public");
  if (!sameTarget) {
    throw new Error("DATABASE_URL và MIGRATION_DATABASE_URL phải cùng host, port, database và schema.");
  }
  if (cleanupRequested && !appIdentity.isSupabasePooler) {
    throw new Error("Cleanup role pooler yêu cầu DATABASE_URL và MIGRATION_DATABASE_URL dạng Supabase pooler.");
  }

  const client = createClient(ownerUrl.toString());
  await client.connect();
  try {
    const { rows: sessionRows } = await client.query("select current_user as database_role");
    const connectedOwnerRole = sessionRows[0]?.database_role;
    if (connectedOwnerRole !== ownerRole) {
      throw new Error(
        `MIGRATION_DATABASE_URL định tuyến tới role "${connectedOwnerRole ?? "<unknown>"}", ` +
          `không phải role mong đợi "${ownerRole}".`
      );
    }

    await provisionAppRole(client, { appRole, appPassword, ownerRole, database, schema });
    await verifyAppConnection({
      createClient: () => createClient(appUrl.toString()),
      expectedRole: appRole,
      retryPoolerAuth: appIdentity.isSupabasePooler,
      sleep
    });
    console.log(
      `Role app "${appRole}" sẵn sàng trên "${database}"/"${schema}": ` +
        "đăng nhập thành công, không có thuộc tính/ownership trực tiếp vượt RLS, " +
        "quyền bảng được giới hạn theo allowlist CRUD."
    );

    if (cleanupRequested) {
      const result = await cleanupLegacyPoolerRole(client, { appIdentity, database, schema });
      if (result.status === "removed") {
        console.log(`Đã thu hồi quyền và xoá role pooler tạo nhầm "${result.role}".`);
      } else {
        console.log(`Không có role pooler tạo nhầm "${result.role}" — không cần cleanup.`);
      }
    } else if (appIdentity.isSupabasePooler) {
      const { rowCount } = await client.query("select 1 from pg_roles where rolname = $1", [
        appIdentity.connectionRole
      ]);
      if (rowCount > 0) {
        console.warn(
          `Phát hiện role pooler tạo nhầm "${appIdentity.connectionRole}". ` +
            "Sau khi kiểm tra role app hoạt động, chạy `pnpm --filter @vexenhanh/api db:app-role:cleanup`."
        );
      }
    }
  } finally {
    await client.end();
  }
}

export async function main(argv = process.argv.slice(2)) {
  const unexpectedArgs = argv.filter((arg) => arg !== CLEANUP_FLAG);
  if (unexpectedArgs.length > 0) {
    throw new Error(`Tham số không hỗ trợ: ${unexpectedArgs.join(", ")}`);
  }

  loadEnv();
  const ownerUrl = requireUrl("MIGRATION_DATABASE_URL");
  const appUrl = requireUrl("DATABASE_URL");
  await runAppRole({ ownerUrl, appUrl, cleanupRequested: argv.includes(CLEANUP_FLAG) });
}

const invokedPath = process.argv[1] ? resolve(process.argv[1]) : undefined;
if (invokedPath === fileURLToPath(import.meta.url)) {
  await main();
}
