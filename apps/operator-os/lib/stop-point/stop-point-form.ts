// Dữ liệu hộp thoại Thêm / Sửa điểm dừng và Đề xuất điểm dừng: kiểm tại chỗ bằng Zod (HLD §6.3) và đổi
// qua lại với DTO của API. Giới hạn độ dài khớp `stop-point.dto.ts` của API.
import { z } from "zod";

import { ApiError } from "../auth/api-client";
import type { StopPoint, StopPointInput, StopPointProposal, StopPointProposalInput } from "./stop-point-api";

export const NAME_MAX_LENGTH = 150;
export const ADDRESS_MAX_LENGTH = 300;
export const DESCRIPTION_MAX_LENGTH = 500;
export const LEGAL_BASIS_MAX_LENGTH = 300;

/** Đổi chữ người dùng gõ thành số; nhận cả dấu phẩy thập phân (`10,75`). Không phải số → `null`. */
export function parseCoordinate(value: string): number | null {
  const text = value.trim().replace(",", ".");
  if (!/^-?\d+(\.\d+)?$/.test(text)) {
    return null;
  }
  return Number(text);
}

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
  description: z.string().max(DESCRIPTION_MAX_LENGTH, `Ghi chú tối đa ${DESCRIPTION_MAX_LENGTH} ký tự.`)
};

/** Luật kiểm form điểm riêng: chỉ văn phòng trung chuyển / trạm dừng nghỉ, trạng thái do nhà xe đặt (BR-38). */
export const stopPointFormSchema = z.object({
  ...locationFields,
  type: z.enum(["OFFICE", "REST_STOP"], "Chọn loại điểm."),
  status: z.enum(["ACTIVE", "INACTIVE"])
});
export type StopPointFormValues = z.infer<typeof stopPointFormSchema>;

/** Luật kiểm form đề xuất: chỉ bến xe / điểm dừng đón trả khách, bắt buộc căn cứ công bố (BR-38). */
export const proposalFormSchema = z.object({
  ...locationFields,
  type: z.enum(["BUS_STATION", "PICKUP_POINT"], "Chọn loại điểm."),
  legalBasis: z
    .string()
    .trim()
    .min(1, "Nhập căn cứ công bố.")
    .max(LEGAL_BASIS_MAX_LENGTH, `Căn cứ công bố tối đa ${LEGAL_BASIS_MAX_LENGTH} ký tự.`)
});
export type ProposalFormValues = z.infer<typeof proposalFormSchema>;

const EMPTY_LOCATION = {
  name: "",
  address: "",
  provinceId: "",
  wardId: "",
  latitude: "",
  longitude: "",
  description: ""
};

/** Giá trị ban đầu của hộp thoại "Thêm điểm dừng"; loại điểm để trống cho người dùng tự chọn. */
export const EMPTY_STOP_POINT_FORM = { ...EMPTY_LOCATION, type: "", status: "ACTIVE" } as unknown as StopPointFormValues;

/** Giá trị ban đầu của hộp thoại "Đề xuất điểm dừng". */
export const EMPTY_PROPOSAL_FORM = { ...EMPTY_LOCATION, type: "", legalBasis: "" } as unknown as ProposalFormValues;

type StoredLocation = Pick<
  StopPoint,
  "name" | "address" | "provinceId" | "wardId" | "latitude" | "longitude" | "description"
>;

function locationValues(stored: StoredLocation) {
  return {
    name: stored.name,
    address: stored.address,
    provinceId: stored.provinceId,
    wardId: stored.wardId,
    latitude: String(stored.latitude),
    longitude: String(stored.longitude),
    description: stored.description ?? ""
  };
}

/** Đưa điểm riêng đã lưu vào form sửa. Chỉ gọi với điểm không bị khóa (điểm bị khóa không sửa được). */
export function toStopPointFormValues(stopPoint: StopPoint): StopPointFormValues {
  return {
    ...locationValues(stopPoint),
    type: stopPoint.type as StopPointFormValues["type"],
    status: stopPoint.status === "INACTIVE" ? "INACTIVE" : "ACTIVE"
  };
}

/** Đưa đề xuất bị từ chối vào form để sửa và gửi lại. */
export function toProposalFormValues(proposal: StopPointProposal): ProposalFormValues {
  return {
    ...locationValues(proposal),
    type: proposal.type as ProposalFormValues["type"],
    legalBasis: proposal.legalBasis
  };
}

function locationInput(values: StopPointFormValues | ProposalFormValues) {
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

/** Body gửi API cho điểm riêng: PUT thay toàn bộ nên luôn gửi đủ mọi trường; ghi chú trống gửi `null`. */
export function toStopPointInput(values: StopPointFormValues): StopPointInput {
  return { ...locationInput(values), type: values.type, status: values.status };
}

/** Body gửi API cho đề xuất. */
export function toProposalInput(values: ProposalFormValues): StopPointProposalInput {
  return { ...locationInput(values), type: values.type, legalBasis: values.legalBasis.trim() };
}

/** Ô của form mà lỗi lưu thuộc về; `null` = lỗi chung của cả hộp thoại. */
export type SaveErrorField = "name" | "type" | "wardId" | null;

/** Đổi lỗi API khi lưu điểm dừng / gửi đề xuất thành thông báo và ô cần sửa (mã lỗi theo 05 API §7.3). */
export function describeSaveError(error: unknown, kind: "stopPoint" | "proposal"): { field: SaveErrorField; message: string } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "STOP_POINT_NAME_CONFLICT":
        return { field: "name", message: "Tên điểm dừng đã tồn tại trong nhà xe." };
      case "STOP_POINT_TYPE_NOT_ALLOWED":
        return { field: "type", message: "Điểm riêng chỉ là văn phòng trung chuyển hoặc trạm dừng nghỉ." };
      case "CATALOG_ITEM_UNAVAILABLE":
        return { field: "wardId", message: "Tỉnh / thành hoặc phường / xã đã ngừng sử dụng. Vui lòng chọn lại." };
      case "STOP_POINT_SUSPENDED":
        return { field: null, message: "Điểm dừng đang bị Platform khóa nên không sửa được." };
      case "STOP_POINT_NOT_FOUND":
        return { field: null, message: "Điểm dừng không còn tồn tại. Vui lòng đóng hộp thoại và tải lại danh sách." };
      case "STOP_POINT_PROPOSAL_STATE_INVALID":
        return { field: null, message: "Đề xuất không còn ở trạng thái bị từ chối nên không gửi lại được." };
      case "STOP_POINT_PROPOSAL_NOT_FOUND":
        return { field: null, message: "Đề xuất không còn tồn tại. Vui lòng đóng hộp thoại và tải lại danh sách." };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại các ô đã nhập." };
    }
  }
  return {
    field: null,
    message:
      kind === "proposal"
        ? "Chưa gửi được đề xuất. Vui lòng kiểm tra kết nối và thử lại."
        : "Chưa lưu được điểm dừng. Vui lòng kiểm tra kết nối và thử lại."
  };
}
