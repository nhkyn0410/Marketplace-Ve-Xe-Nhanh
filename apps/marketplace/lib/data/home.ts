"use server";

import type { components } from "@vexenhanh/api-client";
import { DataResult, unavailable, ok } from "./result";
import { apiRequest } from "./api";
import { getArticles } from "./content";
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
  const result = await getArticles();
  return result.status === "ok" ? ok(result.data.articles.map((a) => ({ id: a.id, title: a.title,
    category: a.category, readTimeText: "", slug: a.slug }))) : result;
}

/**
 * Lấy thông tin banner ưu đãi / VXN Plus.
 * Endpoint: GET /content/banners?placement=home_plus (chưa có trong hợp đồng API).
 */
export async function getHomePlusBanner(): Promise<DataResult<{ readonly title: string; readonly description: string; readonly ctaUrl: string }>> {
  const result = await apiRequest<components["schemas"]["PublicContentListDto_Output"]>("/content-pages?type=BANNER&placement=HOME");
  if (result.status !== "ok") return result;
  const item = result.data.items[0];
  return item ? ok({ title: item.title, description: item.bodyMarkdown, ctaUrl: item.linkUrl ?? "/plus" }) : unavailable("GET /content-pages?type=BANNER&placement=HOME");
}
