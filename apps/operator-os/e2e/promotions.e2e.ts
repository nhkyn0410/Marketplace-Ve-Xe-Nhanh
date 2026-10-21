import { expect, test, type Page } from "@playwright/test";

import { accounts, signInSharedOwner } from "./helpers";

// TASK-PROM-001 (Khuyến mãi, Figma "Nhà xe · Khuyến mãi" 01–02) — nhà xe đặt vé do global-setup seed đã được cấp quyền tự tạo (20% hoặc
// 100.000 ₫, 60 ngày) + một khuyến mãi nền tảng đang chạy chưa tham gia. Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;
const code = `E2ENX${Date.now().toString(36).toUpperCase().slice(-6)}`;

test.beforeAll(async ({ browser }) => {
  const { bookingOperatorSlug, bookingOwner, bookingFixtures } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Khuyến mãi (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  await signInSharedOwner(page, `${bookingOperatorSlug}/${bookingOwner.username}`, bookingOwner.password);
});

test.afterAll(async () => {
  await page.close();
});

test("tạo khuyến mãi trong giới hạn: vượt 20% → không kích hoạt được (báo giới hạn); 10% tối đa 50.000 → kích hoạt → Đang chạy", async () => {
  await page.getByRole("link", { name: "Khuyến mãi", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Khuyến mãi", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByRole("link", { name: "Tạo khuyến mãi" }).click();
  await expect(page.getByRole("region", { name: "Giới hạn được cấp" })).toContainText("20% hoặc 100.000 ₫", FIRST_VISIT);

  await page.getByLabel("Mã khuyến mãi *").fill(code);
  await page.getByLabel("Tên chương trình *").fill("Giảm giữa tuần E2E");
  await page.getByLabel("Mức giảm (%) *").fill("25");
  await page.getByLabel("Giảm tối đa mỗi đơn (₫)").fill("50000");
  await expect(page.getByRole("region", { name: "Giới hạn được cấp" })).toContainText("Mức giảm vượt giới hạn");
  await page.getByRole("button", { name: "Kích hoạt" }).click();
  await expect(page.getByRole("alert").filter({ hasText: "Mức giảm vượt giới hạn 20%." })).toBeVisible(FIRST_VISIT);

  await page.getByLabel("Mức giảm (%) *").fill("10");
  await page.getByRole("button", { name: "Kích hoạt" }).click();
  await expect(page).toHaveURL(/\/promotions\/[0-9a-f-]{36}/, FIRST_VISIT);
  await expect(page.getByText("Đang chạy", { exact: true })).toBeVisible(FIRST_VISIT);

  await page.getByRole("link", { name: "Quay lại danh sách khuyến mãi" }).click();
  const list = page.getByRole("region", { name: "Khuyến mãi của nhà xe" });
  const row = list.getByRole("row").filter({ hasText: code });
  await expect(row).toContainText("10%, tối đa 50.000 ₫", FIRST_VISIT);
  await expect(row).toContainText("Đang chạy");
});

test("khuyến mãi Vé Xe Nhanh: tham gia (nhà xe chịu phần giảm) → Đã tham gia; rời chương trình", async () => {
  await page.getByRole("tab", { name: "Khuyến mãi Vé Xe Nhanh" }).click();
  const list = page.getByRole("region", { name: "Khuyến mãi Vé Xe Nhanh" });
  await list.getByLabel("Tìm kiếm").fill(fixtures.platformPromotionCode);
  const row = list.getByRole("row").filter({ hasText: fixtures.platformPromotionCode });
  await expect(row).toContainText("Chưa tham gia", FIRST_VISIT);
  await row.getByRole("button", { name: "Tham gia" }).click();
  await expect(page.getByRole("status")).toContainText("nhà xe chịu phần giảm", FIRST_VISIT);
  await expect(row).toContainText("Đã tham gia");
  await row.getByRole("button", { name: "Rời chương trình" }).click();
  await expect(row).toContainText("Chưa tham gia", FIRST_VISIT);
});
