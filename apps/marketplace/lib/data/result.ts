/**
 * Kiểu kết quả bọc dữ liệu cho các thao tác lấy dữ liệu của Marketplace.
 */
export type DataResult<T> =
  | { readonly status: "ok"; readonly data: T }
  | { readonly status: "unavailable"; readonly endpoint: string }
  | { readonly status: "error"; readonly endpoint: string; readonly message?: string; readonly httpStatus?: number };

/**
 * Tạo kết quả thành công chứa dữ liệu trả về.
 */
export function ok<T>(data: T): DataResult<T> {
  return {
    status: "ok",
    data
  };
}

/**
 * Tạo kết quả cho endpoint chưa được triển khai và ghi cảnh báo ra console.
 */
export function unavailable(endpoint: string): DataResult<never> {
  console.warn(`[marketplace] chưa có API: ${endpoint}`);
  return {
    status: "unavailable",
    endpoint
  };
}

/**
 * Tạo kết quả lỗi khi gọi API thất bại và ghi lỗi ra console.
 */
export function failed(endpoint: string, message?: string, httpStatus?: number): DataResult<never> {
  console.error(`[marketplace] lỗi gọi API: ${endpoint}`, message ?? "");
  return {
    status: "error",
    endpoint,
    ...(message !== undefined ? { message } : {}),
    ...(httpStatus !== undefined ? { httpStatus } : {})
  };
}
