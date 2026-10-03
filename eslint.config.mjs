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

/**
 * TASK-IAM-003 — hàng rào quanh ngữ cảnh RLS (Postgres policy `app_rls_allows`):
 * - `withSystem/withPlatform/withTenant`, `withScope({ kind: "system" | "platform" })` và hàm dựng
 *   `systemScope/platformScope/tenantScope` chỉ được gọi trong `iam/auth`, `iam/session`, `iam/role`
 *   và `database/`. Module nghiệp vụ (kể cả `iam/user`) chỉ dùng `withScope(authz.db, …)` với scope
 *   do `TenantGuard` trao; `DbScope` có brand nên cũng không tự viết literal được.
 * - `$queryRawUnsafe/$executeRawUnsafe` và chuỗi chứa `set_config`/`app.scope`/`app.operator_id` chỉ
 *   được ở `database/`: tự set GUC là vượt RLS bằng tay.
 * Đây là hàng rào chống lỡ tay, không phải ranh giới bảo mật — review vẫn phải để mắt. File test
 * (`*.spec.ts`) được miễn để còn dựng dữ liệu.
 */
const SCOPE_CALLS = new Set(["withSystem", "withPlatform", "withTenant", "systemScope", "platformScope", "tenantScope"]);
const RAW_UNSAFE = new Set(["$queryRawUnsafe", "$executeRawUnsafe"]);
const GUC_PATTERN = /set_config|app\.scope|app\.operator_id/;

const systemDbContextRule = {
  meta: {
    type: "problem",
    messages: {
      scopeOutsideAllowed:
        "{{name}} vượt/đặt ngữ cảnh RLS — chỉ dùng trong apps/api/src/{iam/auth,iam/session,iam/role,database}. Module nghiệp vụ dùng withScope(authz.db) từ @Authz().",
      rawOutsideDatabase:
        "{{name}} chỉ được dùng trong apps/api/src/database — tự viết SQL/GUC là vượt RLS bằng tay."
    }
  },
  create(context) {
    const filename = normalizePath(context.filename ?? context.getFilename());
    if (!filename.includes(API_SRC_MARKER) || filename.endsWith(".spec.ts") || isDatabaseFile(filename)) {
      return {};
    }
    const scopeAllowed = isScopeAllowed(filename);

    return {
      CallExpression(node) {
        const name = calleeName(node.callee);
        if (!name || scopeAllowed) {
          return;
        }
        if (SCOPE_CALLS.has(name) || (name === "withScope" && isPrivilegedScopeLiteral(node.arguments[0]))) {
          context.report({ node, messageId: "scopeOutsideAllowed", data: { name } });
        }
      },
      MemberExpression(node) {
        if (node.property.type === "Identifier" && RAW_UNSAFE.has(node.property.name)) {
          context.report({ node, messageId: "rawOutsideDatabase", data: { name: node.property.name } });
        }
      },
      Literal(node) {
        if (typeof node.value === "string" && GUC_PATTERN.test(node.value)) {
          context.report({ node, messageId: "rawOutsideDatabase", data: { name: "set_config/app.scope" } });
        }
      },
      TemplateElement(node) {
        if (GUC_PATTERN.test(node.value.raw)) {
          context.report({ node, messageId: "rawOutsideDatabase", data: { name: "set_config/app.scope" } });
        }
      }
    };
  }
};

function isScopeAllowed(filename) {
  return ["iam/auth/", "iam/session/", "iam/role/"].some((dir) =>
    filename.includes(`${API_SRC_MARKER}${dir}`)
  );
}

function calleeName(callee) {
  if (callee.type === "Identifier") {
    return callee.name;
  }
  if (callee.type === "MemberExpression" && callee.property.type === "Identifier") {
    return callee.property.name;
  }
  return undefined;
}

function isPrivilegedScopeLiteral(argument) {
  return (
    argument?.type === "ObjectExpression" &&
    argument.properties.some(
      (property) =>
        property.type === "Property" &&
        ((property.key.type === "Identifier" && property.key.name === "kind") ||
          (property.key.type === "Literal" && property.key.value === "kind")) &&
        property.value.type === "Literal" &&
        (property.value.value === "system" || property.value.value === "platform")
    )
  );
}

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
          "api-db-driver-boundary": apiDbDriverBoundaryRule,
          "system-db-context": systemDbContextRule
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
      "vexenhanh-boundaries/api-db-driver-boundary": "error",
      "vexenhanh-boundaries/system-db-context": "error"
    }
  }
);
