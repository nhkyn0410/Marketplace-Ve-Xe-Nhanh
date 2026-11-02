// Định dạng màn Kiểm duyệt → Ảnh phương tiện (Figma ADM-10b/10c; TASK-ADM-003 phần ảnh xe). Hàm thuần.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";

export const REMOVE_REASON_MAX_LENGTH = 500;

/** "Thời gian tải lên" (Figma ADM-10b mặc định 7 ngày gần nhất). */
export const UPLOAD_WINDOWS = [
  { value: "7", label: "7 ngày gần nhất" },
  { value: "30", label: "30 ngày gần nhất" },
  { value: "90", label: "90 ngày gần nhất" }
] as const;

/** Lý do gỡ ảnh: 3–500 ký tự (API §7.5); `null` = hợp lệ. */
export function removeReasonError(value: string): string | null {
  const length = value.trim().length;
  if (length < 3) {
    return "Nhập lý do (ít nhất 3 ký tự).";
  }
  return length > REMOVE_REASON_MAX_LENGTH ? `Lý do tối đa ${REMOVE_REASON_MAX_LENGTH} ký tự.` : null;
}

/** Biển số đã chuẩn hoá → dạng hiển thị, vd `51B28912` → `51B-289.12` (giống Operator OS). */
export function formatPlateNumber(plateNumber: string): string {
  const match = /^(\d{2}[A-Z]{1,2})(\d{4,5})$/.exec(plateNumber);
  if (!match) {
    return plateNumber;
  }
  const [, series, digits] = match as unknown as [string, string, string];
  return digits.length === 5 ? `${series}-${digits.slice(0, 3)}.${digits.slice(3)}` : `${series}-${digits}`;
}

/** Lỗi gỡ ảnh → câu báo; `refresh` = ảnh đã không còn, tải lại lưới. */
export function describeRemoveError(error: unknown): { message: string; refresh?: boolean } {
  if (!(error instanceof ApiError)) {
    return { message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." };
  }
  if (error.code === "VEHICLE_IMAGE_NOT_FOUND") {
    return { message: "Ảnh này đã bị gỡ hoặc nhà xe vừa thay bộ ảnh. Đã tải lại danh sách.", refresh: true };
  }
  if (error.status === 503) {
    return { message: "Hệ thống tạm thời không phản hồi nên ảnh chưa được gỡ. Vui lòng thử lại sau." };
  }
  return { message: error.message || "Không gỡ được ảnh. Vui lòng thử lại." };
}
