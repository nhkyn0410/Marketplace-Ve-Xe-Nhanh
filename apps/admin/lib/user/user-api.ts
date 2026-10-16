// Gọi API quản lý nhà xe + người dùng cho cổng Admin (05 API §7.5 `/admin/operators`, `/admin/passengers`,
// `/admin/employees`, `/admin/platform-accounts`; FR-ADM-02/03, FR-IAM-08).
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type OperatorPage = Schemas["AdminOperatorPageDto_Output"];
export type AdminOperator = OperatorPage["items"][number];
export type OperatorStatus = AdminOperator["status"];
export type BankChange = Schemas["AdminBankChangeDto_Output"];
export type PassengerPage = Schemas["AdminPassengerPageDto_Output"];
export type Passenger = PassengerPage["items"][number];
export type AccountStatus = Passenger["status"];
export type EmployeePage = Schemas["AdminEmployeePageDto_Output"];
export type Employee = EmployeePage["items"][number];
export type EmployeeRole = Employee["role"];
export type PlatformAccount = Schemas["AdminPlatformAccountDto_Output"];
export type PlatformRole = PlatformAccount["role"];
export type PlatformAccountInput = Schemas["AdminPlatformAccountCreateDto"];

const PAGE_SIZE = "20";

function query(params: Record<string, string | null | undefined>): string {
  const search = new URLSearchParams({ limit: PAGE_SIZE });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      search.set(key, value);
    }
  }
  return search.toString();
}

export function listOperators(
  filters: { q?: string; status?: string; bankChange?: string },
  cursor: string | null
): Promise<OperatorPage> {
  return apiRequest<OperatorPage>(`/admin/operators?${query({ ...filters, cursor })}`);
}

export function suspendOperator(id: string, reason: string): Promise<void> {
  return apiRequest<void>(`/admin/operators/${id}/suspend`, { method: "POST", body: { reason } });
}

export function unsuspendOperator(id: string): Promise<void> {
  return apiRequest<void>(`/admin/operators/${id}/unsuspend`, { method: "POST" });
}

/** Yêu cầu đổi tài khoản nhận tiền đang chờ (số đầy đủ — mỗi lần xem được ghi nhật ký). */
export function getBankChange(id: string): Promise<BankChange> {
  return apiRequest<BankChange>(`/admin/operators/${id}/bank-account-change`);
}

export function approveBankChange(id: string, changeId: string): Promise<void> {
  return apiRequest<void>(`/admin/operators/${id}/bank-account-change/approve`, { method: "POST", body: { changeId } });
}

export function rejectBankChange(id: string, changeId: string, reason: string): Promise<void> {
  return apiRequest<void>(`/admin/operators/${id}/bank-account-change/reject`, { method: "POST", body: { changeId, reason } });
}

export function listPassengers(filters: { q?: string; status?: string }, cursor: string | null): Promise<PassengerPage> {
  return apiRequest<PassengerPage>(`/admin/passengers?${query({ ...filters, cursor })}`);
}

export function lockPassenger(id: string, reason: string): Promise<void> {
  return apiRequest<void>(`/admin/passengers/${encodeURIComponent(id)}/lock`, { method: "POST", body: { reason } });
}

export function unlockPassenger(id: string): Promise<void> {
  return apiRequest<void>(`/admin/passengers/${encodeURIComponent(id)}/unlock`, { method: "POST" });
}

export function listEmployees(
  filters: { q?: string; operatorId?: string; role?: string; status?: string },
  cursor: string | null
): Promise<EmployeePage> {
  return apiRequest<EmployeePage>(`/admin/employees?${query({ ...filters, cursor })}`);
}

export async function listPlatformAccounts(filters: { q?: string; role?: string; status?: string }): Promise<PlatformAccount[]> {
  const search = new URLSearchParams();
  for (const [key, value] of Object.entries(filters)) {
    if (value) {
      search.set(key, value);
    }
  }
  return (await apiRequest<{ items: PlatformAccount[] }>(`/admin/platform-accounts?${search.toString()}`)).items;
}

export function createPlatformAccount(input: PlatformAccountInput): Promise<PlatformAccount> {
  return apiRequest<PlatformAccount>("/admin/platform-accounts", { method: "POST", body: input });
}

export function resetPlatformPassword(id: string): Promise<PlatformAccount> {
  return apiRequest<PlatformAccount>(`/admin/platform-accounts/${id}/reset-password`, { method: "POST" });
}

export function resetPlatformMfa(id: string): Promise<PlatformAccount> {
  return apiRequest<PlatformAccount>(`/admin/platform-accounts/${id}/reset-mfa`, { method: "POST" });
}

export function lockPlatformAccount(id: string, reason: string): Promise<void> {
  return apiRequest<void>(`/admin/platform-accounts/${id}/lock`, { method: "POST", body: { reason } });
}

export function unlockPlatformAccount(id: string): Promise<void> {
  return apiRequest<void>(`/admin/platform-accounts/${id}/unlock`, { method: "POST" });
}
