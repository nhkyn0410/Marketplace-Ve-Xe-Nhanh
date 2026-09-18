// Tạo / cập nhật role Postgres cho app (TASK-IAM-003, quyết định Q3). Idempotent.
//
// Vì sao cần: superuser, role BYPASSRLS và owner bảng (hoặc thành viên role owner) đều vượt được RLS
// (DB-PRIN-01). App chạy bằng role đó thì mọi policy RLS chỉ là trang trí, và test RLS xanh giả.
//
// - `MIGRATION_DATABASE_URL`: owner — dùng để chạy script này, migrate, seed.
// - `DATABASE_URL`: role app — tên + mật khẩu lấy từ chính URL này, script tạo đúng role đó.
//
// THỨ TỰ: `prisma migrate deploy` TRƯỚC, script này SAU (script từ chối chạy nếu chưa migrate — nếu
// không, bảng `_prisma_migrations` tạo sau sẽ thừa hưởng quyền CRUD mặc định cho role app).
//
// Dùng: pnpm --filter @vexenhanh/api db:app-role
import { createHash, createHmac, pbkdf2Sync, randomBytes } from "node:crypto";
import { existsSync } from "node:fs";
import { createRequire } from "node:module";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const { Client } = require("pg");
const apiRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");

// Cùng cơ chế env với app/prisma.config: `.env` rồi `.env.{NODE_ENV}`; biến có sẵn thì giữ nguyên.
const nodeEnv = process.env.NODE_ENV?.trim() || "development";
for (const file of [".env", `.env.${nodeEnv}`]) {
  const path = resolve(apiRoot, file);
  if (existsSync(path)) {
    process.loadEnvFile(path);
  }
}

function requireUrl(key) {
  const value = process.env[key]?.trim();
  if (!value) {
    throw new Error(`${key} chưa set — xem apps/api/.env.example.`);
  }
  return new URL(value);
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

const ownerUrl = requireUrl("MIGRATION_DATABASE_URL");
const appUrl = requireUrl("DATABASE_URL");
const appRole = decodeURIComponent(appUrl.username);
const appPassword = decodeURIComponent(appUrl.password);
const ownerRole = decodeURIComponent(ownerUrl.username);
const database = appUrl.pathname.replace(/^\//, "");
const schema = appUrl.searchParams.get("schema") || "public";

if (!appRole || !appPassword) {
  throw new Error("DATABASE_URL phải có cả user và password của role app.");
}
if (appRole === ownerRole) {
  throw new Error(
    `DATABASE_URL và MIGRATION_DATABASE_URL cùng user "${appRole}". App phải chạy bằng role RIÊNG, ` +
      "không phải owner — nếu không RLS không có tác dụng."
  );
}
// Cấp quyền trên DB/schema của URL owner mà app lại trỏ chỗ khác = cấp nhầm chỗ, app vẫn không chạy.
const sameTarget =
  appUrl.hostname === ownerUrl.hostname &&
  (appUrl.port || "5432") === (ownerUrl.port || "5432") &&
  database === ownerUrl.pathname.replace(/^\//, "") &&
  schema === (ownerUrl.searchParams.get("schema") || "public");
if (!sameTarget) {
  throw new Error("DATABASE_URL và MIGRATION_DATABASE_URL phải cùng host, port, database và schema.");
}

const client = new Client({ connectionString: ownerUrl.toString() });
await client.connect();
try {
  const role = client.escapeIdentifier(appRole);
  const owner = client.escapeIdentifier(ownerRole);
  const ns = client.escapeIdentifier(schema);
  const password = client.escapeLiteral(scramVerifier(appPassword));

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
  await client.query(`ALTER ROLE ${role} IN DATABASE ${client.escapeIdentifier(database)} RESET ALL`);

  const statements = [
    `GRANT CONNECT ON DATABASE ${client.escapeIdentifier(database)} TO ${role}`,
    `GRANT USAGE ON SCHEMA ${ns} TO ${role}`,
    `GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${ns} TO ${role}`,
    `GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA ${ns} TO ${role}`,
    // Bảng do owner tạo ở migration SAU này tự có quyền — khỏi phải nhớ chạy lại script.
    `ALTER DEFAULT PRIVILEGES FOR ROLE ${owner} IN SCHEMA ${ns} GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${role}`,
    `ALTER DEFAULT PRIVILEGES FOR ROLE ${owner} IN SCHEMA ${ns} GRANT USAGE, SELECT ON SEQUENCES TO ${role}`,
    // Lịch sử migrate không phải việc của app (sửa được nó là chặn/lặp được deploy).
    `REVOKE ALL ON TABLE ${ns}."_prisma_migrations" FROM ${role}`,
  ];
  for (const sql of statements) {
    await client.query(sql);
  }

  const { rows } = await client.query(
    `select r.rolsuper, r.rolbypassrls, r.rolcreaterole, r.rolcreatedb, r.rolreplication,
            r.rolconfig,
            exists (select 1 from pg_auth_members m where m.member = r.oid) as is_member
       from pg_roles r where r.rolname = $1`,
    [appRole]
  );
  const [state] = rows;
  const problems = [
    state.rolsuper && "SUPERUSER",
    state.rolbypassrls && "BYPASSRLS",
    state.rolcreaterole && "CREATEROLE",
    state.rolcreatedb && "CREATEDB",
    state.rolreplication && "REPLICATION",
    state.rolconfig && `tham số mặc định ${JSON.stringify(state.rolconfig)}`,
    // Là thành viên role khác (nhất là role owner) thì `SET ROLE owner` rồi tắt RLS được.
    state.is_member && "là thành viên của role khác",
  ].filter(Boolean);
  if (problems.length > 0) {
    throw new Error(
      `Role "${appRole}" vẫn vượt được RLS: ${problems.join(", ")}. Sửa bằng superuser rồi chạy lại script.`
    );
  }
  console.log(`Role app "${appRole}" sẵn sàng trên "${database}"/"${schema}": không vượt được RLS, chỉ CRUD.`);
} finally {
  await client.end();
}
