/**
 * Kiểu tham số tìm kiếm có thể truyền vào hàm lấy preview.
 */
export type SearchParamsInput =
  | { readonly [key: string]: string | readonly string[] | string[] | undefined }
  | URLSearchParams
  | null
  | undefined;

/**
 * Trích xuất tên trạng thái preview từ tham số truy vấn khi ở môi trường phát triển.
 */
export function getPreview(searchParams?: SearchParamsInput): string | null {
  if (process.env.NODE_ENV === "production") {
    return null;
  }

  if (!searchParams) {
    return null;
  }

  if (searchParams instanceof URLSearchParams) {
    const val = searchParams.get("preview");
    return val && val.trim() !== "" ? val : null;
  }

  const raw = searchParams["preview"];
  if (typeof raw === "string" && raw.trim() !== "") {
    return raw;
  }

  if (Array.isArray(raw) && raw.length > 0 && typeof raw[0] === "string" && raw[0].trim() !== "") {
    return raw[0];
  }

  return null;
}
