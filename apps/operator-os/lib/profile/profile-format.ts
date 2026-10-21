// Màn Hồ sơ & KYC của nhà xe (TASK-OPR-001b, UC-11; Figma 1667:27240, 1667:27586): form sửa thông tin công khai, form
// đổi tài khoản nhận tiền, nhãn và thông báo lỗi.
import { z } from "zod";

import { ApiError } from "../auth/api-client";
import { describeReauthError } from "../auth/reauth";
import type { OperatorProfile, ProfileUpdateInput } from "./profile-api";

const digits = (value: string) => value.replace(/[\s.-]/g, "");

/** Form "Chỉnh sửa" hồ sơ doanh nghiệp — cùng ràng buộc với API. */
export const profileFormSchema = z.object({
  displayName: z.string().trim().min(1, "Nhập tên nhà xe.").max(100, "Tên nhà xe tối đa 100 ký tự."),
  hotline: z.string().refine((value) => /^\+?\d{8,15}$/.test(digits(value)), "Hotline gồm 8–15 chữ số."),
  publicEmail: z.string().trim().min(1, "Nhập email liên hệ.").pipe(z.email("Email không hợp lệ.")),
  address: z.string().trim().min(1, "Nhập địa chỉ.").max(255, "Địa chỉ tối đa 255 ký tự."),
  description: z.string().max(1000, "Mô tả tối đa 1000 ký tự.")
});
export type ProfileFormValues = z.infer<typeof profileFormSchema>;

export function toProfileForm(profile: OperatorProfile): ProfileFormValues {
  return {
    displayName: profile.displayName,
    hotline: profile.hotline ?? "",
    publicEmail: profile.publicEmail ?? "",
    address: profile.address ?? "",
    description: profile.description ?? ""
  };
}

export function toProfileInput(values: ProfileFormValues): ProfileUpdateInput {
  return {
    displayName: values.displayName.trim(),
    hotline: digits(values.hotline),
    publicEmail: values.publicEmail.trim(),
    address: values.address.trim(),
    description: values.description.trim() || null
  };
}

/** Tên chủ tài khoản như ngân hàng in: viết hoa, không dấu (máy chủ cũng tự chuẩn hoá). */
export function toAccountHolder(value: string): string {
  return value
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[đĐ]/g, "D")
    .toUpperCase();
}

/** Form "Đổi tài khoản nhận tiền" (Figma 1667:27586). */
export const bankChangeFormSchema = z.object({
  bankName: z.string().min(1, "Chọn ngân hàng."),
  accountNumber: z.string().refine((value) => /^\d{6,20}$/.test(digits(value)), "Số tài khoản gồm 6–20 chữ số."),
  accountHolder: z
    .string()
    .trim()
    .min(1, "Nhập tên chủ tài khoản.")
    .refine((value) => /^[A-Z0-9 .,&()-]{2,100}$/.test(toAccountHolder(value)), "Tên chủ tài khoản viết hoa, không dấu."),
  reason: z.string().trim().min(3, "Nhập lý do (3–500 ký tự).").max(500, "Lý do tối đa 500 ký tự.")
});
export type BankChangeFormValues = z.infer<typeof bankChangeFormSchema>;

/** Hai chữ cái đầu của tên nhà xe cho ô logo (Figma "SV"). */
export function initialsOf(name: string): string {
  const words = name.trim().split(/\s+/).filter(Boolean);
  const letters = words.length > 1 ? `${words[0]![0]}${words[1]![0]}` : (words[0] ?? "").slice(0, 2);
  return letters.toUpperCase();
}

/** `12/08/2026` theo giờ Việt Nam. */
export function formatDate(iso: string): string {
  const parts = new Intl.DateTimeFormat("vi-VN", {
    timeZone: "Asia/Ho_Chi_Minh",
    day: "2-digit",
    month: "2-digit",
    year: "numeric"
  }).formatToParts(new Date(iso));
  const get = (type: Intl.DateTimeFormatPartTypes) => parts.find((part) => part.type === type)?.value ?? "";
  return `${get("day")}/${get("month")}/${get("year")}`;
}

/** Lỗi khi sửa hồ sơ / tải giấy tờ / gửi đổi tài khoản; `field: "identity"` = báo tại ô mật khẩu / mã. */
export function describeProfileError(error: unknown): { field: "identity" | null; message: string } {
  const identity = describeReauthError(error);
  if (identity) {
    return { field: "identity", message: identity };
  }
  if (error instanceof ApiError) {
    switch (error.code) {
      case "BANK_ACCOUNT_CHANGE_PENDING":
        return { field: null, message: "Đã có yêu cầu đổi tài khoản đang chờ xác minh. Chờ kết quả trước khi gửi yêu cầu mới." };
      case "BANK_ACCOUNT_UNCHANGED":
        return { field: null, message: "Tài khoản này đang là tài khoản nhận tiền của nhà xe." };
      case "KYC_DOCUMENT_INVALID":
        return { field: null, message: "Giấy tờ không hợp lệ hoặc chưa tải lên xong. Hãy tải lại." };
      case "KYC_DOCUMENT_NOT_FOUND":
        return { field: null, message: "Nhà xe chưa có giấy tờ này." };
    }
    if (error.status === 503) {
      return { field: null, message: "Hệ thống tạm thời chưa xử lý được nên chưa đổi gì. Vui lòng thử lại sau." };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại các ô đã nhập." };
    }
  }
  return { field: null, message: "Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại." };
}
