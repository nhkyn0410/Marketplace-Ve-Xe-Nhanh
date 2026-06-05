import { resolve } from "node:path";
import { ESLint } from "eslint";
import { describe, expect, it } from "vitest";

const eslintConfigPath = resolve(process.cwd(), "../../eslint.config.mjs");

describe("api db driver boundary ESLint rule", () => {
  it("rejects Mongoose imports outside audit and database modules", async () => {
    const messages = await lintApiSource(
      "src/booking/booking.repository.ts",
      'import { Schema } from "mongoose";\nexport const value = Schema;\n'
    );

    expect(messages).toContain(
      "Mongoose is only allowed in apps/api/src/audit and apps/api/src/database."
    );
  });

  it("allows Mongoose imports inside the audit module", async () => {
    const messages = await lintApiSource(
      "src/audit/audit-event.schema.ts",
      'import { Schema } from "mongoose";\nexport const value = Schema;\n'
    );

    expect(messages).not.toContain(
      "Mongoose is only allowed in apps/api/src/audit and apps/api/src/database."
    );
  });

  it("rejects Prisma imports outside the database module", async () => {
    const messages = await lintApiSource(
      "src/audit/bad-prisma-import.ts",
      'import { PrismaClient } from "../generated/prisma/client";\nexport const value = PrismaClient;\n'
    );

    expect(messages).toContain(
      "Prisma driver/client imports are only allowed in apps/api/src/database."
    );
  });
});

async function lintApiSource(relativeFilePath: string, code: string): Promise<string[]> {
  const eslint = new ESLint({ overrideConfigFile: eslintConfigPath });
  const [result] = await eslint.lintText(code, {
    filePath: resolve(process.cwd(), relativeFilePath)
  });

  return result.messages.map((message) => message.message);
}
