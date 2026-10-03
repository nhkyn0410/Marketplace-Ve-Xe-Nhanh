import { SubjectType } from "../../database/prisma.types";

/**
 * JWT có `scope` **3 giá trị**, bảng `auth_sessions` có `subject_type` **4**.
 * Scope `operator` gộp cả `operator_accounts` lẫn `employee_accounts`, nên KHÔNG
 * bao giờ được gán thẳng scope vào subject_type: `revokeAllForSubject('operator', id)`
 * sẽ quét luôn employee và đá nhầm tài xế ra khỏi app (quyết định Q2, 16/09/2026).
 *
 * Bảng nguồn quyết định, không phải scope.
 */
export function subjectTypeOf(
  source: "user" | "operator_account" | "employee_account" | "platform_account",
): SubjectType {
  switch (source) {
    case "user":
      return SubjectType.PASSENGER;
    case "operator_account":
      return SubjectType.OPERATOR;
    case "employee_account":
      return SubjectType.EMPLOYEE;
    case "platform_account":
      return SubjectType.PLATFORM;
  }
}

/** `user_ref` phải khớp CHECK constraint trong migration: `lower(type) || ':' || id`. */

export function userRefOf(subjectType: SubjectType, subjectId: string): string {
  return `${subjectType.toLowerCase()}:${subjectId}`;
}
