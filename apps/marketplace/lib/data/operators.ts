"use server";

import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "./api";
import { ok, type DataResult } from "./result";
import type { OperatorProfileData } from "./types";
import { formatDateVi } from "../format";

/** Lấy hồ sơ công khai của nhà xe, chỉ dùng chỉ số và đánh giá API cung cấp. */
export async function getOperatorProfile(operatorId: string, cursor?: string): Promise<DataResult<OperatorProfileData>> {
  const query = cursor ? `?${new URLSearchParams({ cursor })}` : "";
  const result = await apiRequest<components["schemas"]["PublicOperatorProfileDto_Output"]>(`/operators/${encodeURIComponent(operatorId)}/public-profile${query}`);
  if (result.status !== "ok") return result;
  const p = result.data;
  const percent = (value: number | null) => value === null ? "Chưa có dữ liệu" : `${(value * 100).toFixed(1)}%`;
  return ok({ id: p.operatorId, name: p.displayName, code: p.operatorSlug.slice(0, 2).toUpperCase(),
    logoUrl: p.logoUrl, isVerified: false, description: p.description ?? "", hotline: p.hotline ?? "", email: p.publicEmail ?? "",
    headquarters: p.address ?? "", metrics: { ratingAverageText: p.scorecard.averageRating?.toFixed(1) ?? "—",
      ratingTotalText: `${p.scorecard.reviewCount} đánh giá`, cancellationRateText: percent(p.scorecard.operatorCancellationRate),
      cancellationRatePeriod: "", refundDisputeRateText: `${percent(p.scorecard.refundBookingRate)} / ${percent(p.scorecard.disputeBookingRate)}`,
      refundDisputePeriod: "", checkinRateText: percent(p.scorecard.checkInRate), checkinRateNote: "" },
    featuredRoutes: p.routes.map((r) => ({ id: r.routeId, routeName: r.name, metaText: "", imageUrl: "",
      searchUrl: "" })),
    reviews: p.reviews.map((r) => ({ id: r.reviewId, authorName: r.authorName, authorInitial: r.authorName.slice(0, 1),
      routeAndDateText: formatDateVi(r.createdAt), rating: r.rating, content: r.comment ?? "" })),
    terms: p.serviceTerms ? [p.serviceTerms.title, p.serviceTerms.contentMarkdown] : [], nextReviewCursor: p.nextReviewCursor });
}
