import type { VerifiedAccessToken } from "../auth/token.service";

export type AccountActor = Pick<
  VerifiedAccessToken,
  "sub" | "sid" | "scope" | "role" | "operatorId" | "operatorSlug"
>;

export type AccountRequestContext = {
  ip?: string;
  userAgent?: string;
};

/**
 * Username Employee = `nv.` + phần Owner đặt; Owner cấm tiền tố này (ADR-017 amend 28/09/2026).
 * Hai cổng login tách theo bảng account, tiền tố cho người dùng/FE biết account thuộc cổng nào.
 * DB CHECK `employee_accounts_username_employee_prefix` / `operator_accounts_username_not_employee_prefix`
 * giữ cùng quy tắc.
 */
export const EMPLOYEE_USERNAME_PREFIX = "nv.";
export const EMPLOYEE_USERNAME_PATTERN = /^nv\.[a-z0-9._-]{2,61}$/;

export type ProvisionOperatorOwnerInput = {
  /** OPR-001 có thể truyền id của hồ sơ KYC đã duyệt; bỏ trống thì service sinh UUID. */
  operatorId?: string;
  operatorSlug: string;
  displayName: string;
  ownerUsername: string;
  contactEmail: string;
  reason: string;
};

export type ProvisionedOperatorOwner = {
  operatorId: string;
  ownerAccountId: string;
};

/** DTO chặn ở HTTP; primitive/service vẫn chặn lại để caller nội bộ không bypass audit reason. */
export function requireAccountReason(value: string): string {
  const reason = value.trim();
  if (reason.length < 3) {
    throw new Error("Account mutation requires a reason of at least 3 characters.");
  }
  return reason;
}
