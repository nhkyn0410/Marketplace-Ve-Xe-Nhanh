"use server";

import type { components } from "@vexenhanh/api-client";
import { DataResult, unavailable, ok } from "./result";
import { apiRequest } from "./api";
import { getArticles } from "./content";
import { mapFeaturedOperator, mapPopularRoute } from "./home-mappers";
import {
  FeaturedOperatorItem,
  HandbookArticleItem,
  PopularRouteItem
} from "./types";

/** Tuyến xe phổ biến cho trang chủ (`GET /catalog/popular-routes`, tối đa 7 thẻ theo Figma). */
export async function getPopularRoutes(): Promise<DataResult<readonly PopularRouteItem[]>> {
  const result = await apiRequest<components["schemas"]["PopularRouteListResponseDto_Output"]>("/catalog/popular-routes?limit=7");
  return result.status === "ok" ? ok(result.data.items.map((route, index) => mapPopularRoute(route, index))) : result;
}

/** Nhà xe đối tác tiêu biểu (`GET /catalog/featured-operators`, 5 thẻ theo Figma). */
export async function getFeaturedOperators(): Promise<DataResult<readonly FeaturedOperatorItem[]>> {
  const result = await apiRequest<components["schemas"]["FeaturedOperatorListResponseDto_Output"]>("/catalog/featured-operators?limit=5");
  return result.status === "ok" ? ok(result.data.items.map(mapFeaturedOperator)) : result;
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
