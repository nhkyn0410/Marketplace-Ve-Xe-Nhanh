// Gọi API hồ sơ nhà xe cho Operator OS (05 API §7.3 `/operator/profile`; TASK-OPR-001b). Kiểu lấy từ client sinh tự
// OpenAPI nên DTO backend đổi mà chưa sửa ở đây thì typecheck đỏ. Đổi tài khoản nhận tiền cần xác nhận lại danh tính
// trong 5 phút gần nhất (`lib/auth/reauth.ts`).
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type OperatorProfile = Schemas["OperatorProfileResponseDto_Output"];
export type ProfileUpdateInput = Schemas["OperatorProfileUpdateDto"];
export type BankChangeInput = Schemas["BankChangeInputDto"];
export type KycDocument = OperatorProfile["documents"][number];
export type KycDocumentType = KycDocument["type"];
export type LogoUpload = Schemas["LogoUploadResponseDto_Output"];
export type LogoContentType = Schemas["LogoUploadInputDto"]["contentType"];
/** Hồ sơ công khai mà hành khách thấy (05 API `/operators/{operatorId}/public-profile`) — dùng cho khung xem trước. */
export type PublicOperatorProfile = Schemas["PublicOperatorProfileDto_Output"];

export function getProfile(): Promise<OperatorProfile> {
  return apiRequest<OperatorProfile>("/operator/profile");
}

/** Hồ sơ công khai của nhà xe kèm 3 đánh giá mới nhất; nhà xe đang tạm khóa → 404 `OPERATOR_NOT_FOUND`. */
export function getPublicProfile(operatorId: string): Promise<PublicOperatorProfile> {
  return apiRequest<PublicOperatorProfile>(`/operators/${encodeURIComponent(operatorId)}/public-profile?limit=3`);
}

/** Đổi logo bằng ảnh đã thu nhỏ: xin URL, `PUT` thẳng ảnh lên kho công khai, rồi gắn vào hồ sơ (logo cũ bị xóa). */
export async function uploadLogo(image: Blob): Promise<OperatorProfile> {
  const contentType = image.type as LogoContentType;
  const grant = await apiRequest<LogoUpload>("/operator/profile/logo/upload-url", {
    method: "POST",
    body: { contentType, sizeBytes: image.size }
  });
  const response = await fetch(grant.uploadUrl, {
    method: "PUT",
    headers: { "Content-Type": image.type },
    body: image,
    credentials: "omit"
  });
  if (!response.ok) {
    throw new Error(`Tải logo lên kho thất bại (${response.status}).`);
  }
  return apiRequest<OperatorProfile>("/operator/profile/logo", { method: "PUT", body: { objectKey: grant.objectKey } });
}

/** Gỡ logo — trang nhà xe quay về chữ viết tắt. */
export function removeLogo(): Promise<OperatorProfile> {
  return apiRequest<OperatorProfile>("/operator/profile/logo", { method: "DELETE" });
}

/** Sửa thông tin công khai; tên pháp lý / mã số thuế không sửa ở đây. */
export function updateProfile(input: ProfileUpdateInput): Promise<OperatorProfile> {
  return apiRequest<OperatorProfile>("/operator/profile", { method: "PUT", body: input });
}

/** Tải bản mới của một giấy tờ: xin URL, `PUT` thẳng file lên kho riêng tư, rồi gắn vào hồ sơ. */
export async function replaceKycDocument(type: KycDocumentType, file: File): Promise<OperatorProfile> {
  const grant = await apiRequest<{ uploadUrl: string; objectKey: string }>("/operator/profile/documents/upload-url", {
    method: "POST",
    body: { contentType: file.type, sizeBytes: file.size }
  });
  const response = await fetch(grant.uploadUrl, {
    method: "PUT",
    headers: { "Content-Type": file.type },
    body: file,
    credentials: "omit"
  });
  if (!response.ok) {
    throw new Error(`Tải giấy tờ lên kho thất bại (${response.status}).`);
  }
  return apiRequest<OperatorProfile>(`/operator/profile/documents/${type}`, {
    method: "PUT",
    body: { objectKey: grant.objectKey, fileName: file.name }
  });
}

/** URL xem một giấy tờ (hạn 5 phút; mỗi lần mở được ghi nhật ký). */
export async function kycDocumentUrl(type: KycDocumentType): Promise<string> {
  return (await apiRequest<{ url: string }>(`/operator/profile/documents/${type}/download-url`, { method: "POST" })).url;
}

/** Gửi yêu cầu đổi tài khoản nhận tiền — chờ Admin xác minh, tài khoản cũ vẫn dùng tới lúc đó. */
export function requestBankChange(input: BankChangeInput): Promise<OperatorProfile> {
  return apiRequest<OperatorProfile>("/operator/profile/bank-account-change", { method: "POST", body: input });
}
