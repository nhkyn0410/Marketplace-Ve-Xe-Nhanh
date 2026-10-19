import { DataResult, unavailable } from "./result";
import {
  FeaturedOperatorItem,
  HandbookArticleItem,
  PopularRouteItem
} from "./types";

/**
 * Lấy danh sách tuyến xe phổ biến.
 * Endpoint: GET /catalog/popular-routes (chưa có trong hợp đồng API).
 */
export async function getPopularRoutes(): Promise<DataResult<readonly PopularRouteItem[]>> {
  return Promise.resolve(unavailable("GET /catalog/popular-routes"));
}

/**
 * Lấy danh sách nhà xe đối tác tiêu biểu.
 * Endpoint: GET /catalog/featured-operators (chưa có trong hợp đồng API).
 */
export async function getFeaturedOperators(): Promise<DataResult<readonly FeaturedOperatorItem[]>> {
  return Promise.resolve(unavailable("GET /catalog/featured-operators"));
}

/**
 * Lấy bài viết cẩm nang xe khách.
 * Endpoint: GET /content/articles?tag=handbook (chưa có trong hợp đồng API).
 */
export async function getHandbookArticles(): Promise<DataResult<readonly HandbookArticleItem[]>> {
  return Promise.resolve(unavailable("GET /content/articles?tag=handbook"));
}

/**
 * Lấy thông tin banner ưu đãi / VXN Plus.
 * Endpoint: GET /content/banners?placement=home_plus (chưa có trong hợp đồng API).
 */
export async function getHomePlusBanner(): Promise<DataResult<{ readonly title: string; readonly description: string; readonly ctaUrl: string }>> {
  return Promise.resolve(unavailable("GET /content/banners?placement=home_plus"));
}
