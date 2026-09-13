import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";

const API_SRC_MARKER = "/apps/api/src/";

const apiDbDriverBoundaryRule = {
  meta: {
    type: "problem",
    messages: {
      mongooseOutsideAudit:
        "Mongoose is only allowed in apps/api/src/audit and apps/api/src/database.",
      prismaOutsideDatabase: "Prisma driver/client imports are only allowed in apps/api/src/database."
    }
  },
  create(context) {
    const filename = normalizePath(context.filename ?? context.getFilename());

    return {
      ImportDeclaration(node) {
        const source = node.source.value;

        if (typeof source !== "string" || !filename.includes(API_SRC_MARKER)) {
          return;
        }

        if (isGeneratedPrismaFile(filename)) {
          return;
        }

        if (isMongooseImport(source) && !isAuditOrDatabaseFile(filename)) {
          context.report({ node, messageId: "mongooseOutsideAudit" });
          return;
        }

        if (isPrismaImport(source) && !isDatabaseFile(filename)) {
          context.report({ node, messageId: "prismaOutsideDatabase" });
        }
      }
    };
  }
};

function normalizePath(path) {
  return path.replaceAll("\\", "/");
}

function isAuditOrDatabaseFile(filename) {
  return filename.includes(`${API_SRC_MARKER}audit/`) || isDatabaseFile(filename);
}

function isDatabaseFile(filename) {
  return filename.includes(`${API_SRC_MARKER}database/`);
}

function isGeneratedPrismaFile(filename) {
  return filename.includes(`${API_SRC_MARKER}generated/prisma/`);
}

function isMongooseImport(source) {
  return source === "mongoose" || source === "@nestjs/mongoose";
}

function isPrismaImport(source) {
  return (
    source === "@prisma/client" ||
    source === "@prisma/adapter-pg" ||
    normalizePath(source).includes("/generated/prisma/")
  );
}

export default tseslint.config(
  {
    ignores: [
      "**/dist/**",
      "**/.next/**",
      "**/.turbo/**",
      "**/coverage/**",
      "**/node_modules/**"
    ]
  },
  {
    files: ["**/*.{js,mjs,cjs}"],
    extends: [js.configs.recommended],
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.browser
      }
    }
  },
  {
    files: ["**/*.{ts,tsx}"],
    extends: [...tseslint.configs.recommended],
    plugins: {
      "vexenhanh-boundaries": {
        rules: {
          "api-db-driver-boundary": apiDbDriverBoundaryRule
        }
      }
    },
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.browser
      }
    },
    rules: {
      "@typescript-eslint/no-unused-vars": [
        "error",
        {
          "argsIgnorePattern": "^_",
          "varsIgnorePattern": "^_"
        }
      ],
      "vexenhanh-boundaries/api-db-driver-boundary": "error"
    }
  }
);
