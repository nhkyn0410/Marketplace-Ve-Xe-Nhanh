"use client";

import { useEffect } from "react";
import { LAST_SEARCH_COOKIE } from "../../lib/data/trip-mappers";

/** 30 ngày — đủ để quay lại trang Khám phá vẫn thấy tuyến vừa tìm. */
const MAX_AGE_SECONDS = 30 * 24 * 60 * 60;

/**
 * Ghi điều kiện hành trình vừa tìm vào cookie để trang Khám phá (Mua vé) mở lại đúng tuyến, như app giữ lần tìm trước.
 * Chỉ điểm đi / đến, ngày, số khách — không có dữ liệu cá nhân. Trình duyệt chặn cookie thì Khám phá dùng tuyến phổ biến.
 */
export function RememberLastSearch({ query }: { readonly query: string }) {
  useEffect(() => {
    try {
      document.cookie = `${LAST_SEARCH_COOKIE}=${encodeURIComponent(query)}; path=/; max-age=${MAX_AGE_SECONDS}; samesite=lax`;
    } catch {
      // Bỏ qua: không ghi được cookie thì Khám phá dùng tuyến phổ biến.
    }
  }, [query]);
  return null;
}
