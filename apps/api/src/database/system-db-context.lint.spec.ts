import { resolve } from "node:path";
import { ESLint } from "eslint";
import { beforeAll, describe, expect, it } from "vitest";

/**
 * Rule `vexenhanh-boundaries/system-db-context` (eslint.config.mjs, TASK-IAM-003): `withSystem` bỏ
 * qua RLS nên chỉ được gọi trong `iam/` + `database/`. Chạy ESLint thật với config của repo.
 */
// Không phụ thuộc thư mục chạy lệnh: file này ở apps/api/src/database → lên 4 cấp là repo root.
const repoRoot = resolve(__dirname, "../../../..");
const RULE = "vexenhanh-boundaries/system-db-context";

describe("ESLint system-db-context", () => {
  let eslint: ESLint;

  // Lần lint đầu nạp typescript-eslint mất ~10 giây — làm nóng ở đây để từng test không timeout.
  beforeAll(async () => {
    eslint = new ESLint({ cwd: repoRoot });
    await eslint.lintText("export {};", {
      filePath: resolve(repoRoot, "apps/api/src/warmup.ts"),
    });
  }, 60_000);

  async function ruleHits(relativePath: string, code: string): Promise<number> {
    const [result] = await eslint.lintText(code, {
      filePath: resolve(repoRoot, relativePath),
    });
    return (result?.messages ?? []).filter((message) => message.ruleId === RULE).length;
  }

  const systemCall = "declare const prisma: any;\nvoid prisma.withSystem(async () => 1);\n";
  const systemScopeCall =
    'declare const prisma: any;\nvoid prisma.withScope({ kind: "system" }, async () => 1);\n';

  it("chặn withSystem / withScope(system) trong module nghiệp vụ", async () => {
    expect(await ruleHits("apps/api/src/booking/booking.service.ts", systemCall)).toBe(1);
    expect(await ruleHits("apps/api/src/booking/booking.service.ts", systemScopeCall)).toBe(1);
  });

  it("cho phép trong iam/ và database/", async () => {
    expect(await ruleHits("apps/api/src/iam/session/session.service.ts", systemCall)).toBe(0);
    expect(await ruleHits("apps/api/src/database/prisma.service.ts", systemCall)).toBe(0);
  });

  it("module nghiệp vụ cũng không được tự dựng ngữ cảnh platform/tenant (audit M3)", async () => {
    const snippets = [
      "declare const prisma: any;\nvoid prisma.withPlatform(async () => 1);\n",
      "declare const prisma: any;\nvoid prisma.withTenant(\"x\", async () => 1);\n",
      'declare const prisma: any;\nvoid prisma.withScope({ kind: "platform" }, async () => 1);\n',
      "declare const platformScope: any;\nvoid platformScope();\n",
    ];
    for (const code of snippets) {
      expect(await ruleHits("apps/api/src/booking/booking.service.ts", code), code).toBe(1);
    }
    // iam/user cũng là module nghiệp vụ (CRUD account tenant) — chỉ auth/session/role được miễn.
    expect(await ruleHits("apps/api/src/iam/user/user.service.ts", systemCall)).toBe(1);
    expect(await ruleHits("apps/api/src/iam/role/tenant.guard.ts", "declare const platformScope: any;\nvoid platformScope();\n")).toBe(0);
  });

  it("chặn tự set GUC / SQL không tham số hoá ngoài database/", async () => {
    const guc = "declare const tx: any;\nvoid tx.$executeRaw`SELECT set_config('app.scope', 'system', true)`;\n";
    const unsafe = "declare const prisma: any;\nvoid prisma.$queryRawUnsafe('select 1');\n";
    expect(await ruleHits("apps/api/src/booking/booking.service.ts", guc)).toBe(1);
    expect(await ruleHits("apps/api/src/booking/booking.service.ts", unsafe)).toBe(1);
    expect(await ruleHits("apps/api/src/database/prisma.service.ts", guc)).toBe(0);
  });

  it("dùng scope guard trao (biến) thì hợp lệ", async () => {
    const guarded = "declare const prisma: any; declare const authz: any;\nvoid prisma.withScope(authz.db, async () => 1);\n";
    expect(await ruleHits("apps/api/src/booking/booking.service.ts", guarded)).toBe(0);
  });
});
