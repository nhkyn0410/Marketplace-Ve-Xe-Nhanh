import { resolve } from "node:path";
import { ESLint } from "eslint";
import { describe, expect, it } from "vitest";

const eslintConfigPath = resolve(process.cwd(), "../../eslint.config.mjs");

// ESLint-in-process là tác vụ nặng (nạp flat config + typescript-eslint). Tái dùng 1 instance
// + nới timeout để không flaky khi suite chạy song song dưới tải import ESM nặng.
const LINT_TIMEOUT_MS = 30_000;
let sharedEslint: ESLint | undefined;

describe("api db driver boundary ESLint rule", () => {
  it(
    "rejects Mongoose imports outside audit and database modules",
    async () => {
      const messages = await lintApiSource(
        "src/booking/booking.repository.ts",
        'import { Schema } from "mongoose";\nexport const value = Schema;\n'
      );

      expect(messages).toContain(
        "Mongoose is only allowed in apps/api/src/audit and apps/api/src/database."
      );
    },
    LINT_TIMEOUT_MS
  );

  it(
    "allows Mongoose imports inside the audit module",
    async () => {
      const messages = await lintApiSource(
        "src/audit/audit-event.schema.ts",
        'import { Schema } from "mongoose";\nexport const value = Schema;\n'
      );

      expect(messages).not.toContain(
        "Mongoose is only allowed in apps/api/src/audit and apps/api/src/database."
      );
    },
    LINT_TIMEOUT_MS
  );

  it(
    "rejects Prisma imports outside the database module",
    async () => {
      const messages = await lintApiSource(
        "src/audit/bad-prisma-import.ts",
        'import { PrismaClient } from "../generated/prisma/client";\nexport const value = PrismaClient;\n'
      );

      expect(messages).toContain(
        "Prisma driver/client imports are only allowed in apps/api/src/database."
      );
    },
    LINT_TIMEOUT_MS
  );
});

async function lintApiSource(relativeFilePath: string, code: string): Promise<string[]> {
  sharedEslint ??= new ESLint({ overrideConfigFile: eslintConfigPath });
  const [result] = await sharedEslint.lintText(code, {
    filePath: resolve(process.cwd(), relativeFilePath)
  });

  return result.messages.map((message) => message.message);
}
