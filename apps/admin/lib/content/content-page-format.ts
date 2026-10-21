// Logic thuần của tab "Nội dung công khai" (Figma ADM-10d) và trang soạn nội dung (TASK-ADM-003 — trang soạn chưa có khung
// Figma): nhãn loại / vị trí / tình trạng, kiểm form giống máy chủ, dựng body API, đọc lỗi lưu.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";

import type { ContentPageInput, ContentPageStatus, ContentPageType, ContentPlacement } from "./content-page-api";

export const CONTENT_TITLE_MAX = 160;
export const CONTENT_BODY_MAX = 20_000;
export const CONTENT_SLUG_MAX = 80;

export const TYPE_LABEL: Record<ContentPageType, string> = {
  FAQ: "Câu hỏi thường gặp",
  BANNER: "Banner",
  PAGE: "Trang tĩnh"
};
export const TYPE_ORDER: ContentPageType[] = ["FAQ", "BANNER", "PAGE"];

export const PLACEMENT_LABEL: Record<ContentPlacement, string> = {
  HOME: "Trang chủ",
  FOOTER: "Chân trang",
  BOOKING: "Đặt vé và thanh toán",
  TICKET: "Đổi, hủy và hoàn vé",
  ACCOUNT: "Tài khoản"
};

/** Vị trí hợp lệ theo loại (giống máy chủ). */
export const PLACEMENTS_BY_TYPE: Record<ContentPageType, ContentPlacement[]> = {
  BANNER: ["HOME"],
  PAGE: ["FOOTER"],
  FAQ: ["BOOKING", "TICKET", "ACCOUNT"]
};

export const CONTENT_STATUS: Record<ContentPageStatus, { label: string; tone: "neutral" | "success" }> = {
  DRAFT: { label: "Bản nháp", tone: "neutral" },
  PUBLISHED: { label: "Đang hiển thị", tone: "success" }
};

/** Nhãn ô nội dung theo loại. */
export const BODY_LABEL: Record<ContentPageType, string> = {
  FAQ: "Câu trả lời *",
  PAGE: "Nội dung trang *",
  BANNER: "Dòng phụ"
};

export type ContentFormValues = {
  type: ContentPageType;
  placement: ContentPlacement;
  title: string;
  slug: string;
  bodyMarkdown: string;
  imageKey: string | null;
  linkUrl: string;
  displayOrder: string;
};
export type ContentField = keyof ContentFormValues | "form";

export function emptyContentValues(type: ContentPageType = "FAQ"): ContentFormValues {
  return { type, placement: PLACEMENTS_BY_TYPE[type][0]!, title: "", slug: "", bodyMarkdown: "", imageKey: null, linkUrl: "", displayOrder: "0" };
}

/** Đổi loại (chỉ khi tạo mới): vị trí về vị trí đầu của loại mới, bỏ trường không thuộc loại đó. */
export function changeType(values: ContentFormValues, type: ContentPageType): ContentFormValues {
  return {
    ...values,
    type,
    placement: PLACEMENTS_BY_TYPE[type][0]!,
    slug: type === "PAGE" ? values.slug : "",
    imageKey: type === "BANNER" ? values.imageKey : null,
    linkUrl: type === "BANNER" ? values.linkUrl : ""
  };
}

const SLUG = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;
const LINK = /^(\/(?!\/)\S*|https:\/\/\S+)$/;

/** Lỗi theo ô (giống máy chủ); rỗng = gửi được. */
export function contentErrors(values: ContentFormValues): Partial<Record<ContentField, string>> {
  const errors: Partial<Record<ContentField, string>> = {};
  if (values.title.trim() === "") {
    errors.title = "Nhập tiêu đề.";
  } else if (values.title.trim().length > CONTENT_TITLE_MAX) {
    errors.title = `Tiêu đề tối đa ${CONTENT_TITLE_MAX} ký tự.`;
  }
  if (values.type === "PAGE" && !SLUG.test(values.slug)) {
    errors.slug = "Đường dẫn chỉ gồm chữ thường không dấu, số và gạch nối.";
  }
  if (values.type === "BANNER" && !values.imageKey) {
    errors.imageKey = "Tải ảnh banner lên.";
  }
  if (values.type === "BANNER" && values.linkUrl.trim() !== "" && !LINK.test(values.linkUrl.trim())) {
    errors.linkUrl = "Liên kết bắt đầu bằng / (trang trong Vé Xe Nhanh) hoặc https://.";
  }
  if (values.type !== "BANNER" && values.bodyMarkdown.trim() === "") {
    errors.bodyMarkdown = "Nhập nội dung.";
  }
  if (!/^\d{1,3}$/.test(values.displayOrder.trim())) {
    errors.displayOrder = "Nhập số từ 0 đến 999.";
  }
  return errors;
}

export function toContentInput(values: ContentFormValues): ContentPageInput {
  return {
    type: values.type,
    placement: values.placement,
    title: values.title.trim(),
    slug: values.type === "PAGE" ? values.slug : null,
    bodyMarkdown: values.bodyMarkdown,
    imageKey: values.type === "BANNER" ? values.imageKey : null,
    linkUrl: values.type === "BANNER" && values.linkUrl.trim() !== "" ? values.linkUrl.trim() : null,
    displayOrder: Number(values.displayOrder)
  };
}

/** Lỗi khi lưu / đổi trạng thái → ô cần báo + câu. */
export function describeContentError(error: unknown): { field: ContentField; message: string } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "CONTENT_PAGE_SLUG_CONFLICT":
        return { field: "slug", message: "Đường dẫn này đã có trang khác dùng." };
      case "CONTENT_IMAGE_INVALID":
        return { field: "imageKey", message: "Ảnh chưa tải lên xong hoặc không hợp lệ. Tải lại ảnh." };
      case "CONTENT_PAGE_STATE_INVALID":
        return { field: "form", message: "Trạng thái nội dung vừa thay đổi ở nơi khác. Tải lại trang." };
      case "CONTENT_PAGE_NOT_FOUND":
        return { field: "form", message: "Nội dung không còn tồn tại." };
    }
    if (error.status === 503) {
      return { field: "form", message: "Chưa ghi được nhật ký nên thay đổi chưa được lưu. Vui lòng thử lại." };
    }
    if (error.status === 400) {
      return { field: "form", message: "Thông tin chưa hợp lệ. Kiểm tra lại các ô." };
    }
  }
  return { field: "form", message: "Chưa lưu được. Kiểm tra kết nối rồi thử lại." };
}
