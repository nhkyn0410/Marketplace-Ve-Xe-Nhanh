// Chữ hiển thị + form của màn Điểm dừng cổng Admin (Figma ADM-05a…05e; TASK-ADM-004). Hàm thuần để test được.
// Giới hạn độ dài khớp DTO của API (`admin-stop-point.dto.ts`).
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError } from "@vexenhanh/ui/lib/auth/reauth";
import { parseCoordinate } from "@vexenhanh/ui/lib/stop-map";
import { z } from "zod";

import type {
  OperatorStopPointStatus,
  Proposal,
  ProposalApprovalInput,
  ProposalStatus,
  SharedStatus,
  SharedStopPoint,
  SharedStopPointInput,
  StopPointType
} from "./stop-point-api";

type Tone = "success" | "warning" | "neutral" | "danger";

export const STOP_POINT_TYPE_LABELS: Record<StopPointType, string> = {
  BUS_STATION: "Bến xe khách",
  PICKUP_POINT: "Điểm dừng đón trả khách",
  OFFICE: "Văn phòng trung chuyển",
  REST_STOP: "Trạm dừng nghỉ"
};

/** Loại của danh mục dùng chung (BR-38), theo thứ tự ô lọc. */
export const SHARED_TYPES = ["BUS_STATION", "PICKUP_POINT", "REST_STOP"] as const;
/** Loại nhà xe đề xuất được. */
export const PROPOSAL_TYPES = ["BUS_STATION", "PICKUP_POINT"] as const;
/** Loại điểm riêng của nhà xe. */
export const OPERATOR_POINT_TYPES = ["OFFICE", "REST_STOP"] as const;

export const SHARED_STATUS: Record<SharedStatus, { label: string; tone: Tone }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  INACTIVE: { label: "Ngừng dùng", tone: "neutral" }
};

export const OPERATOR_POINT_STATUS: Record<OperatorStopPointStatus, { label: string; tone: Tone }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  INACTIVE: { label: "Ngừng dùng", tone: "neutral" },
  SUSPENDED: { label: "Bị khóa", tone: "danger" }
};

export const PROPOSAL_STATUS: Record<ProposalStatus, { label: string; tone: Tone }> = {
  PENDING: { label: "Chờ duyệt", tone: "warning" },
  APPROVED: { label: "Đã duyệt", tone: "success" },
  REJECTED: { label: "Bị từ chối", tone: "danger" }
};

/** `1284` → `1.284` (số đếm trên tab, chân bảng). */
export function formatCount(value: number): string {
  return value.toLocaleString("vi-VN");
}

/** Cảnh báo ngắn ở cột "Cảnh báo" của danh sách đề xuất; `null` = không có điểm cùng loại ở gần. */
export function nearbyWarning(proposal: Pick<Proposal, "nearby">): string | null {
  const nearest = proposal.nearby[0];
  return nearest ? `Điểm cùng loại cách ${nearest.distanceMeters} m` : null;
}

export const NAME_MAX_LENGTH = 150;
export const ADDRESS_MAX_LENGTH = 300;
export const DESCRIPTION_MAX_LENGTH = 500;
export const LEGAL_BASIS_MAX_LENGTH = 300;
export const REASON_MAX_LENGTH = 500;

function coordinate(max: number, label: string) {
  return z
    .string()
    .trim()
    .min(1, `Nhập ${label}.`)
    .refine((value) => {
      const parsed = parseCoordinate(value);
      return value === "" || (parsed !== null && Math.abs(parsed) <= max);
    }, `${label[0]!.toUpperCase()}${label.slice(1)} là số từ -${max} đến ${max}.`);
}

const locationFields = {
  name: z.string().trim().min(1, "Nhập tên điểm dừng.").max(NAME_MAX_LENGTH, `Tên tối đa ${NAME_MAX_LENGTH} ký tự.`),
  address: z.string().trim().min(1, "Nhập địa chỉ.").max(ADDRESS_MAX_LENGTH, `Địa chỉ tối đa ${ADDRESS_MAX_LENGTH} ký tự.`),
  provinceId: z.string().min(1, "Chọn tỉnh / thành."),
  wardId: z.string().min(1, "Chọn phường / xã."),
  latitude: coordinate(90, "vĩ độ"),
  longitude: coordinate(180, "kinh độ"),
  description: z.string().max(DESCRIPTION_MAX_LENGTH, `Ghi chú tối đa ${DESCRIPTION_MAX_LENGTH} ký tự.`),
  legalBasis: z.string().trim().max(LEGAL_BASIS_MAX_LENGTH, `Căn cứ công bố tối đa ${LEGAL_BASIS_MAX_LENGTH} ký tự.`)
};

const NEEDS_LEGAL_BASIS = "Bến xe và điểm dừng đón trả bắt buộc căn cứ công bố.";

/** Form thêm / sửa điểm dùng chung: bến xe / điểm dừng đón trả bắt buộc căn cứ công bố (BR-38). */
export const sharedFormSchema = z
  .object({
    ...locationFields,
    type: z.enum(SHARED_TYPES, "Chọn loại điểm."),
    status: z.enum(["ACTIVE", "INACTIVE"])
  })
  .refine((values) => values.type === "REST_STOP" || values.legalBasis.trim() !== "", {
    path: ["legalBasis"],
    message: NEEDS_LEGAL_BASIS
  });
export type SharedFormValues = z.infer<typeof sharedFormSchema>;

/** Form duyệt đề xuất: Admin chỉnh được tên, loại, địa chỉ, tọa độ, căn cứ trước khi duyệt. */
export const approvalFormSchema = z.object({
  ...locationFields,
  type: z.enum(PROPOSAL_TYPES, "Chọn loại điểm."),
  legalBasis: locationFields.legalBasis.min(1, NEEDS_LEGAL_BASIS)
});
export type ApprovalFormValues = z.infer<typeof approvalFormSchema>;

/** Dạng chung của form (chuỗi cho mọi ô) để một bộ ô nhập dùng cho cả hai form. */
export type LocationFormValues = {
  name: string;
  type: string;
  status: string;
  address: string;
  provinceId: string;
  wardId: string;
  latitude: string;
  longitude: string;
  legalBasis: string;
  description: string;
};

export const EMPTY_SHARED_FORM: LocationFormValues = {
  name: "",
  type: "",
  status: "ACTIVE",
  address: "",
  provinceId: "",
  wardId: "",
  latitude: "",
  longitude: "",
  legalBasis: "",
  description: ""
};

type StoredLocation = Pick<
  SharedStopPoint,
  "name" | "type" | "address" | "provinceId" | "wardId" | "latitude" | "longitude" | "description"
> & { legalBasis: string | null };

function storedValues(stored: StoredLocation): LocationFormValues {
  return {
    name: stored.name,
    type: stored.type,
    status: "ACTIVE",
    address: stored.address,
    provinceId: stored.provinceId,
    wardId: stored.wardId,
    latitude: String(stored.latitude),
    longitude: String(stored.longitude),
    legalBasis: stored.legalBasis ?? "",
    description: stored.description ?? ""
  };
}

export function toSharedFormValues(stopPoint: SharedStopPoint): LocationFormValues {
  return { ...storedValues(stopPoint), status: stopPoint.status };
}

export function toApprovalFormValues(proposal: Proposal): LocationFormValues {
  return storedValues(proposal);
}

function locationInput(values: SharedFormValues | ApprovalFormValues) {
  const description = values.description.trim();
  return {
    name: values.name.trim(),
    address: values.address.trim(),
    provinceId: values.provinceId,
    wardId: values.wardId,
    latitude: parseCoordinate(values.latitude)!,
    longitude: parseCoordinate(values.longitude)!,
    description: description === "" ? null : description
  };
}

/** Body thêm / sửa điểm dùng chung (PUT thay toàn bộ nên luôn gửi đủ); căn cứ trống gửi `null`. */
export function toSharedInput(values: SharedFormValues): SharedStopPointInput {
  const legalBasis = values.legalBasis.trim();
  return { ...locationInput(values), type: values.type, status: values.status, legalBasis: legalBasis === "" ? null : legalBasis };
}

export function toApprovalInput(values: ApprovalFormValues): ProposalApprovalInput {
  return { ...locationInput(values), type: values.type, legalBasis: values.legalBasis.trim() };
}

export function reasonError(reason: string): string | null {
  const length = reason.trim().length;
  if (length === 0) {
    return "Nhập lý do.";
  }
  return length > REASON_MAX_LENGTH ? `Lý do tối đa ${REASON_MAX_LENGTH} ký tự.` : null;
}

/** Ô của form mà lỗi lưu thuộc về; `form` = lỗi chung. `refresh` = dữ liệu trên màn có thể đã cũ. */
export type DescribedError = { field: "wardId" | "legalBasis" | "form"; message: string; refresh?: boolean };

export function describeStopPointError(error: unknown): DescribedError {
  const identity = describeReauthError(error);
  if (identity) {
    return { field: "form", message: identity };
  }
  if (!(error instanceof ApiError)) {
    return { field: "form", message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." };
  }
  switch (error.code) {
    case "CATALOG_ITEM_UNAVAILABLE":
      return { field: "wardId", message: "Tỉnh / thành hoặc phường / xã đã ngừng sử dụng. Vui lòng chọn lại." };
    case "STOP_POINT_PROPOSAL_STATE_INVALID":
      return { field: "form", message: "Đề xuất không còn ở trạng thái Chờ duyệt (có thể vừa được xử lý). Đã tải lại.", refresh: true };
    case "STOP_POINT_STATE_INVALID":
      return { field: "form", message: "Trạng thái điểm dừng vừa thay đổi. Đã tải lại danh sách.", refresh: true };
    case "STOP_POINT_NOT_FOUND":
    case "STOP_POINT_PROPOSAL_NOT_FOUND":
      return { field: "form", message: "Không còn tìm thấy mục này. Đã tải lại danh sách.", refresh: true };
    case "VALIDATION_FAILED":
      return { field: "form", message: "Thông tin chưa hợp lệ. Kiểm tra lại các ô rồi thử lại." };
    default:
      return error.status === 503
        ? { field: "form", message: "Hệ thống tạm thời không phản hồi nên chưa lưu được. Vui lòng thử lại sau." }
        : { field: "form", message: error.message || "Không thực hiện được thao tác. Vui lòng thử lại." };
  }
}
