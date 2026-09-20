import { describe, expect, it, vi } from "vitest";

import {
  cleanupLegacyPoolerRole,
  parseDatabaseUrl,
  parseRoleIdentity,
  provisionAppRole,
  resolveRoleIdentities,
  runAppRole,
  validateRolePasswords,
  verifyAppConnection
} from "./db-app-role.mjs";

const PROJECT_REF = "abcdefghijklmnopqrst";
const OTHER_PROJECT_REF = "tsrqponmlkjihgfedcba";

function poolerUrl(role, projectRef = PROJECT_REF, port = 5432) {
  return new URL(
    `postgresql://${role}.${projectRef}:test-password-abcdefghijklmnopqrstuvwxyz@aws-1-ap-southeast-1.pooler.supabase.com:${port}/postgres?schema=public&sslmode=verify-full`
  );
}

function safeCleanupState(overrides = {}) {
  return {
    rolsuper: false,
    rolbypassrls: false,
    rolcreaterole: false,
    rolcreatedb: false,
    rolreplication: false,
    rolconfig: null,
    is_current: false,
    is_member_of_other_role: false,
    has_unexpected_members: false,
    owns_objects: false,
    ...overrides
  };
}

function mockCleanupClient(states) {
  const queue = [...states];
  return {
    escapeIdentifier: (value) => `"${value.replaceAll('"', '""')}"`,
    query: vi.fn(async (sql) => {
      if (sql.includes("from pg_roles r")) {
        const state = queue.shift();
        return { rows: state ? [state] : [] };
      }
      return { rows: [] };
    })
  };
}

function safeProvisionState(overrides = {}) {
  return {
    rolsuper: false,
    rolbypassrls: false,
    rolcreaterole: false,
    rolcreatedb: false,
    rolreplication: false,
    rolconfig: null,
    is_member_of_other_role: false,
    has_unexpected_members: false,
    owns_objects: false,
    has_extra_table_privileges: false,
    has_extra_sequence_privileges: false,
    can_create_in_schema: false,
    ...overrides
  };
}

function mockProvisionClient(state = safeProvisionState()) {
  return {
    escapeIdentifier: (value) => `"${value.replaceAll('"', '""')}"`,
    escapeLiteral: (value) => `'${value.replaceAll("'", "''")}'`,
    query: vi.fn(async (sql) => {
      if (sql.includes("information_schema.tables")) return { rowCount: 1, rows: [] };
      if (sql === "select 1 from pg_roles where rolname = $1") return { rowCount: 1, rows: [{}] };
      if (sql.includes("has_extra_table_privileges")) return { rows: [state] };
      return { rowCount: 0, rows: [] };
    })
  };
}

function mockConnectionClient(databaseRole, connectError) {
  return {
    connect: vi.fn(async () => {
      if (connectError) throw connectError;
    }),
    query: vi.fn(async () => ({ rows: [{ database_role: databaseRole }] })),
    end: vi.fn(async () => undefined)
  };
}

describe("db-app-role Supabase pooler identity", () => {
  it("redacts credentials when a database URL is malformed", () => {
    const secret = "DO_NOT_LOG_THIS_SECRET";
    const malformed = `postgresql://postgres:${secret}@[invalid-host/postgres`;

    let error;
    try {
      parseDatabaseUrl(malformed, "DATABASE_URL");
    } catch (reason) {
      error = reason;
    }

    expect(error).toBeInstanceOf(Error);
    expect(error.message).toContain("DATABASE_URL không phải PostgreSQL URL hợp lệ");
    expect(error.message).not.toContain(secret);
  });

  it("keeps direct connection roles unchanged", () => {
    const identity = parseRoleIdentity(
      new URL("postgresql://vexenhanh_app:secret@localhost:5432/vexenhanh_dev"),
      "DATABASE_URL"
    );

    expect(identity).toEqual({
      connectionRole: "vexenhanh_app",
      sqlRole: "vexenhanh_app",
      projectRef: undefined,
      isSupabasePooler: false
    });
  });

  it("normalizes routing usernames only for the Supabase session pooler", () => {
    const { owner, app } = resolveRoleIdentities(poolerUrl("postgres"), poolerUrl("vexenhanh_app"));

    expect(owner).toMatchObject({
      connectionRole: `postgres.${PROJECT_REF}`,
      sqlRole: "postgres",
      projectRef: PROJECT_REF,
      isSupabasePooler: true
    });
    expect(app).toMatchObject({
      connectionRole: `vexenhanh_app.${PROJECT_REF}`,
      sqlRole: "vexenhanh_app",
      projectRef: PROJECT_REF,
      isSupabasePooler: true
    });
  });

  it("uses the last dot so a real role name may contain dots", () => {
    const identity = parseRoleIdentity(poolerUrl("team.app"), "DATABASE_URL");

    expect(identity.sqlRole).toBe("team.app");
    expect(identity.projectRef).toBe(PROJECT_REF);
  });

  it("rejects malformed or transaction-pooler routing usernames", () => {
    const missingRef = new URL(
      "postgresql://postgres:test-password-abcdefghijklmnopqrstuvwxyz@aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=verify-full"
    );

    expect(() => parseRoleIdentity(missingRef, "MIGRATION_DATABASE_URL")).toThrow(
      "<role>.<PROJECT_REF>"
    );
    expect(() => parseRoleIdentity(poolerUrl("postgres", PROJECT_REF, 6543), "MIGRATION_DATABASE_URL")).toThrow(
      "cổng 5432"
    );
  });

  it("requires full certificate verification for Supabase pooler URLs", () => {
    const insecureUrl = poolerUrl("postgres");
    insecureUrl.searchParams.set("sslmode", "require");
    const duplicatedUrl = poolerUrl("postgres");
    duplicatedUrl.searchParams.append("sslmode", "disable");

    expect(() => parseRoleIdentity(insecureUrl, "MIGRATION_DATABASE_URL")).toThrow(
      "sslmode=verify-full"
    );
    expect(() => parseRoleIdentity(duplicatedUrl, "MIGRATION_DATABASE_URL")).toThrow(
      "sslmode=verify-full"
    );
  });

  it("rejects mixed connection modes, mismatched refs and equal normalized roles", () => {
    const directOwner = new URL("postgresql://postgres:secret@localhost:5432/postgres");

    expect(() => resolveRoleIdentities(directOwner, poolerUrl("vexenhanh_app"))).toThrow(
      "không được trộn"
    );
    expect(() =>
      resolveRoleIdentities(poolerUrl("postgres"), poolerUrl("vexenhanh_app", OTHER_PROJECT_REF))
    ).toThrow("cùng Supabase PROJECT_REF");
    expect(() => resolveRoleIdentities(poolerUrl("postgres"), poolerUrl("postgres"))).toThrow(
      "cùng Postgres role"
    );
  });

  it("requires a password dedicated to the app role", () => {
    const ownerUrl = poolerUrl("postgres");
    const reusedPasswordUrl = poolerUrl("vexenhanh_app");
    const dedicatedPasswordUrl = new URL(reusedPasswordUrl);
    dedicatedPasswordUrl.password = "different-app-secret-abcdefghijklmnopqrstuvwxyz";

    expect(() => validateRolePasswords(ownerUrl, reusedPasswordUrl)).toThrow(
      "không được trùng mật khẩu owner"
    );
    expect(
      validateRolePasswords(ownerUrl, dedicatedPasswordUrl, { requireStrongAppPassword: true })
    ).toEqual({
      appPassword: "different-app-secret-abcdefghijklmnopqrstuvwxyz"
    });

    const weakPasswordUrl = new URL(dedicatedPasswordUrl);
    weakPasswordUrl.password = "too-short";
    expect(() =>
      validateRolePasswords(ownerUrl, weakPasswordUrl, { requireStrongAppPassword: true })
    ).toThrow("ít nhất 32 ký tự ASCII");

    const unicodeOwnerUrl = poolerUrl("postgres");
    const unicodeAppUrl = poolerUrl("vexenhanh_app");
    unicodeOwnerUrl.password = "p\u00e4ssword";
    unicodeAppUrl.password = "pa\u0308ssword";
    expect(() => validateRolePasswords(unicodeOwnerUrl, unicodeAppUrl)).toThrow(
      "không được trùng mật khẩu owner"
    );
  });
});

describe("db-app-role legacy pooler cleanup", () => {
  const appIdentity = parseRoleIdentity(poolerUrl("vexenhanh_app"), "DATABASE_URL");
  const cleanupInput = { appIdentity, database: "postgres", schema: "public" };

  it("is idempotent when the legacy role is absent", async () => {
    const client = mockCleanupClient([undefined, undefined]);

    await expect(cleanupLegacyPoolerRole(client, cleanupInput)).resolves.toEqual({
      status: "absent",
      role: `vexenhanh_app.${PROJECT_REF}`
    });
    await expect(cleanupLegacyPoolerRole(client, cleanupInput)).resolves.toMatchObject({ status: "absent" });
    expect(client.query).toHaveBeenCalledTimes(2);
  });

  it.each([
    ["elevated", { rolsuper: true }],
    ["outgoing membership", { is_member_of_other_role: true }],
    ["unexpected incoming member", { has_unexpected_members: true }],
    ["ownership", { owns_objects: true }]
  ])("refuses cleanup when the legacy role has %s state", async (_label, unsafeState) => {
    const client = mockCleanupClient([safeCleanupState(unsafeState)]);

    await expect(cleanupLegacyPoolerRole(client, cleanupInput)).rejects.toThrow("Từ chối cleanup");
    expect(client.query).toHaveBeenCalledTimes(1);
  });

  it("does not expose role configuration values when cleanup is refused", async () => {
    const secret = "DO_NOT_LOG_THIS_SECRET";
    const client = mockCleanupClient([safeCleanupState({ rolconfig: [`app.secret=${secret}`] })]);

    const error = await cleanupLegacyPoolerRole(client, cleanupInput).catch((reason) => reason);

    expect(error).toBeInstanceOf(Error);
    expect(error.message).toContain("có tham số mặc định");
    expect(error.message).not.toContain(secret);
  });

  it("revokes only the known legacy grants and drops the exact derived role", async () => {
    const client = mockCleanupClient([safeCleanupState()]);

    await expect(cleanupLegacyPoolerRole(client, cleanupInput)).resolves.toEqual({
      status: "removed",
      role: `vexenhanh_app.${PROJECT_REF}`
    });

    const statements = client.query.mock.calls.map(([sql]) => sql);
    expect(statements).toContain("BEGIN");
    expect(statements).toContain(`DROP ROLE "vexenhanh_app.${PROJECT_REF}"`);
    expect(statements.at(-1)).toBe("COMMIT");
    expect(statements.join("\n")).not.toMatch(/DROP OWNED|REASSIGN OWNED/);
    expect(statements[0]).toContain("member_role.rolname <> current_user");
  });

  it("rolls back if PostgreSQL finds an unexpected remaining dependency", async () => {
    const client = mockCleanupClient([safeCleanupState()]);
    client.query.mockImplementation(async (sql) => {
      if (sql.includes("from pg_roles r")) {
        return { rows: [safeCleanupState()] };
      }
      if (sql.startsWith("DROP ROLE")) {
        throw new Error("dependent objects still exist");
      }
      return { rows: [] };
    });

    await expect(cleanupLegacyPoolerRole(client, cleanupInput)).rejects.toThrow(
      "dependent objects still exist"
    );
    expect(client.query.mock.calls.map(([sql]) => sql).at(-1)).toBe("ROLLBACK");
  });
});

describe("db-app-role provisioning safety", () => {
  const provisionInput = {
    appRole: "vexenhanh_app",
    appPassword: "dedicated-app-password",
    ownerRole: "postgres",
    database: "postgres",
    schema: "public"
  };

  it("revokes stale direct/default grants before applying the CRUD allowlist", async () => {
    const client = mockProvisionClient();

    await provisionAppRole(client, provisionInput);

    const statements = client.query.mock.calls.map(([sql]) => sql);
    const revokeIndex = statements.indexOf(
      'REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA "public" FROM "vexenhanh_app"'
    );
    const grantIndex = statements.indexOf(
      'GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "public" TO "vexenhanh_app"'
    );
    expect(revokeIndex).toBeGreaterThan(-1);
    expect(grantIndex).toBeGreaterThan(revokeIndex);
    expect(statements).toContain(
      'ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL PRIVILEGES ON TABLES FROM "vexenhanh_app"'
    );
    expect(statements.at(-1)).toBe("COMMIT");
    const safetyCall = client.query.mock.calls.find(([sql]) => sql.includes("has_unexpected_members"));
    expect(safetyCall[0]).toContain("member_role.rolname <> $3");
    expect(safetyCall[1]).toEqual(["vexenhanh_app", "public", "postgres"]);
  });

  it.each([
    ["outgoing role membership", { is_member_of_other_role: true }],
    ["unexpected incoming member", { has_unexpected_members: true }],
    ["object ownership", { owns_objects: true }],
    ["extra table privileges", { has_extra_table_privileges: true }],
    ["extra sequence privileges", { has_extra_sequence_privileges: true }],
    ["schema CREATE", { can_create_in_schema: true }]
  ])("rolls back when the app role retains %s", async (_label, unsafeState) => {
    const client = mockProvisionClient(safeProvisionState(unsafeState));

    await expect(provisionAppRole(client, provisionInput)).rejects.toThrow("Role \"vexenhanh_app\"");
    expect(client.query.mock.calls.map(([sql]) => sql).at(-1)).toBe("ROLLBACK");
  });

  it("does not expose role configuration values in provisioning errors", async () => {
    const secret = "DO_NOT_LOG_THIS_SECRET";
    const client = mockProvisionClient(
      safeProvisionState({ rolconfig: [`app.secret=${secret}`] })
    );

    const error = await provisionAppRole(client, provisionInput).catch((reason) => reason);

    expect(error).toBeInstanceOf(Error);
    expect(error.message).toContain("có tham số mặc định");
    expect(error.message).not.toContain(secret);
  });
});

describe("db-app-role connection verification", () => {
  it("accepts a pooler connection only when PostgreSQL resolves it to the app role", async () => {
    const client = mockConnectionClient("vexenhanh_app");

    await expect(
      verifyAppConnection({ createClient: () => client, expectedRole: "vexenhanh_app" })
    ).resolves.toBeUndefined();
    expect(client.connect).toHaveBeenCalledOnce();
    expect(client.end).toHaveBeenCalledOnce();
  });

  it("rejects a pooler connection resolved to another role and still closes it", async () => {
    const client = mockConnectionClient("postgres");

    await expect(
      verifyAppConnection({ createClient: () => client, expectedRole: "vexenhanh_app" })
    ).rejects.toThrow('DATABASE_URL định tuyến tới role "postgres"');
    expect(client.end).toHaveBeenCalledOnce();
  });

  it("retries a transient Supabase credential-cache failure with a fresh client", async () => {
    const transientError = Object.assign(new Error("password authentication failed"), {
      code: "28P01"
    });
    const clients = [
      mockConnectionClient(undefined, transientError),
      mockConnectionClient("vexenhanh_app")
    ];
    const createClient = vi.fn(() => clients.shift());
    const sleep = vi.fn(async () => undefined);
    const onRetry = vi.fn();

    await verifyAppConnection({
      createClient,
      expectedRole: "vexenhanh_app",
      retryPoolerAuth: true,
      sleep,
      onRetry
    });

    expect(createClient).toHaveBeenCalledTimes(2);
    expect(sleep).toHaveBeenCalledWith(1_000);
    expect(onRetry).toHaveBeenCalledOnce();
  });
});

describe("db-app-role pooler orchestration", () => {
  it("keeps routing usernames for connections but provisions only normalized SQL roles", async () => {
    const ownerUrl = poolerUrl("postgres");
    const appUrl = poolerUrl("vexenhanh_app");
    appUrl.password = "dedicated-app-password-abcdefghijklmnopqrstuvwxyz";
    const ownerClient = mockProvisionClient();
    const originalOwnerQuery = ownerClient.query;
    ownerClient.connect = vi.fn(async () => undefined);
    ownerClient.end = vi.fn(async () => undefined);
    ownerClient.query = vi.fn(async (sql, params) => {
      if (sql === "select current_user as database_role") {
        return { rows: [{ database_role: "postgres" }] };
      }
      if (sql === "select 1 from pg_roles where rolname = $1") {
        return { rowCount: 0, rows: [] };
      }
      return originalOwnerQuery(sql, params);
    });
    const appClient = mockConnectionClient("vexenhanh_app");
    const createClient = vi.fn((connectionString) => {
      const username = decodeURIComponent(new URL(connectionString).username);
      return username.startsWith("postgres.") ? ownerClient : appClient;
    });
    const log = vi.spyOn(console, "log").mockImplementation(() => undefined);

    try {
      await runAppRole({ ownerUrl, appUrl, createClient, sleep: async () => undefined });
    } finally {
      log.mockRestore();
    }

    const connectionUsers = createClient.mock.calls.map(([connectionString]) =>
      decodeURIComponent(new URL(connectionString).username)
    );
    expect(connectionUsers).toEqual([
      `postgres.${PROJECT_REF}`,
      `vexenhanh_app.${PROJECT_REF}`
    ]);
    const sql = ownerClient.query.mock.calls.map(([statement]) => statement).join("\n");
    expect(sql).toContain('CREATE ROLE "vexenhanh_app"');
    expect(sql).not.toContain(`CREATE ROLE "vexenhanh_app.${PROJECT_REF}"`);
  });
});
