import { expect, test, type Page } from "@playwright/test";

import { accounts, signInSharedOwner } from "./helpers";

// TASK-TRUST-001 (Hỗ trợ, Figma "Nhà xe · Hỗ trợ" 01–03) — nhà xe đặt vé do global-setup seed: khiếu nại Vé Xe Nhanh đã chuyển
// cho nhà xe, tranh chấp đang chờ nhà xe phản hồi, đánh giá 4 sao. Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
const PDF = Buffer.from("%PDF-1.7\n% E2E\n");
let page: Page;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;

test.beforeAll(async ({ browser }) => {
  const { bookingOperatorSlug, bookingOwner, bookingFixtures } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Hỗ trợ (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  await signInSharedOwner(page, `${bookingOperatorSlug}/${bookingOwner.username}`, bookingOwner.password);
});

test.afterAll(async () => {
  await page.close();
});

test("khiếu nại đã chuyển nhà xe: xem trao đổi, phản hồi khách kèm minh chứng → Đang xử lý", async () => {
  await page.getByRole("link", { name: "Hỗ trợ", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Hỗ trợ", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByRole("button", { name: new RegExp(fixtures.forwardedTicketSubject) }).click();
  const detail = page.getByRole("region", { name: fixtures.forwardedTicketSubject });
  await expect(detail).toContainText("Chờ nhà xe phản hồi", FIRST_VISIT);
  await expect(detail).toContainText("Điều hòa trên xe không hoạt động");
  await expect(detail).toContainText("CSKH Vé Xe Nhanh");

  await detail.getByLabel("Phản hồi cho hành khách").fill("Nhà xe đã kiểm tra và bảo dưỡng điều hòa xe.");
  await detail.getByLabel("Đính kèm minh chứng").setInputFiles({ name: "bien-ban-bao-duong.pdf", mimeType: "application/pdf", buffer: PDF });
  await expect(detail.getByText(/bien-ban-bao-duong\.pdf/)).toBeVisible(FIRST_VISIT);
  await detail.getByRole("button", { name: "Gửi phản hồi" }).click();
  await expect(detail).toContainText("Đang xử lý", FIRST_VISIT);
  await expect(detail.getByRole("region", { name: "Trao đổi" })).toContainText("Nhà xe đã kiểm tra");
  await expect(detail.getByRole("region", { name: "Trao đổi" }).getByRole("button", { name: /bien-ban-bao-duong\.pdf/ })).toBeVisible();
});

test("tranh chấp: yêu cầu của Vé Xe Nhanh có hạn → gửi giải trình → Đang xem xét", async () => {
  await page.getByRole("tab", { name: /Tranh chấp/ }).click();
  await page.getByRole("button", { name: new RegExp(fixtures.disputeTitle) }).click();
  const detail = page.getByRole("region", { name: fixtures.disputeTitle });
  await expect(detail).toContainText("Cung cấp nhật trình chuyến", FIRST_VISIT);
  await expect(detail).toContainText("Hạn phản hồi");
  await detail.getByLabel("Giải trình của nhà xe").fill("Xe gặp kẹt xe tại cửa ngõ, tài xế đã báo tổng đài.");
  await detail.getByRole("button", { name: "Gửi phản hồi" }).click();
  await expect(detail).toContainText("Đang xem xét", FIRST_VISIT);
  await expect(detail.getByRole("region", { name: "Giải trình đã gửi" })).toContainText("Xe gặp kẹt xe");
});

test("đánh giá: điểm trung bình, viết phản hồi → Đã phản hồi", async () => {
  await page.getByRole("tab", { name: "Đánh giá" }).click();
  const section = page.getByRole("region", { name: "Đánh giá" });
  const item = section.getByRole("listitem").filter({ hasText: fixtures.reviewComment });
  await expect(item).toContainText("Chưa phản hồi", FIRST_VISIT);
  await expect(section).toContainText("4,0");
  await item.getByRole("button", { name: "Viết phản hồi" }).click();
  await item.getByLabel("Phản hồi đánh giá").fill("Cảm ơn chị đã tin tưởng nhà xe.");
  await item.getByRole("button", { name: "Lưu phản hồi" }).click();
  await expect(item).toContainText("Đã phản hồi", FIRST_VISIT);
  await expect(item).toContainText("Cảm ơn chị đã tin tưởng nhà xe.");
});

test("sự cố và nhật trình: nhà xe chưa có báo cáo thấy trạng thái trống cùng quy tắc báo Admin", async () => {
  await page.getByRole("tab", { name: "Sự cố và nhật trình" }).click();
  await expect(page.getByRole("region", { name: "Sự cố đã báo" })).toContainText("Chưa có sự cố", FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Sự cố đã báo" })).toContainText("Sự cố nghiêm trọng và khẩn cấp tự động báo");
  await expect(page.getByRole("region", { name: "Nhật trình chuyến" })).toContainText("Chưa có nhật trình", FIRST_VISIT);
});
