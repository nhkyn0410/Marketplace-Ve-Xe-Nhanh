import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it, vi } from "vitest";

import { TicketReviewBlock } from "./ticket-review-block";
import type { TicketReviewState } from "../../lib/data/types";

vi.mock("../../lib/data/auth", () => ({ submitTripReview: vi.fn() }));

const render = (initial: TicketReviewState) => renderToStaticMarkup(<TicketReviewBlock bookingId="booking-1" initial={initial} />);

// PASSENGER-PARITY W15 / Q20: khối đánh giá dưới thẻ vé, như app.
describe("khối đánh giá ở chi tiết vé", () => {
  it("chuyến đủ điều kiện: mời đánh giá bằng form chấm sao + nhận xét", () => {
    const html = render({ review: null, canReview: true });
    expect(html).toContain("Chuyến đi đã hoàn thành");
    expect(html).toContain("Bạn chấm chuyến đi mấy sao?");
    expect(html).toContain("Gửi đánh giá");
  });

  it("đã gửi và đang chờ duyệt: hiện sao, nhận xét, ghi chú duyệt; không còn form", () => {
    const html = render({ review: { rating: 4, comment: "Xe sạch, đúng giờ.", status: "HELD" }, canReview: false });
    expect(html).toContain("Đánh giá của bạn");
    expect(html).toContain("4 trên 5 sao");
    expect(html).toContain("Xe sạch, đúng giờ.");
    expect(html).toContain("Đánh giá đang chờ duyệt");
    expect(html).not.toContain("Gửi đánh giá");
  });

  it("đánh giá đang hiển thị thì không kèm ghi chú duyệt", () => {
    const html = render({ review: { rating: 5, comment: "", status: "VISIBLE" }, canReview: false });
    expect(html).toContain("Đánh giá của bạn");
    expect(html).not.toContain("chờ duyệt");
  });

  it("chưa đủ điều kiện và chưa đánh giá: không chiếm chỗ", () => {
    expect(render({ review: null, canReview: false })).toBe("");
  });
});
