import { readFile } from "node:fs/promises";

import { expect, test, type Page } from "@playwright/test";

import { accounts, signInSharedOwner } from "./helpers";

// TASK-RPT-001 (Tổng quan + Báo cáo, Figma "Nhà xe · Báo cáo / Tổng hợp") — nhà xe đặt vé do global-setup seed: chuyến 22:30 ngày
// `date` (xe 4 chỗ) có đơn đã xác nhận A01 + A02 (300.000 ₫ / vé). Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;

test.beforeAll(async ({ browser }) => {
  const { bookingOperatorSlug, bookingOwner, bookingFixtures } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Báo cáo (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  await signInSharedOwner(page, `${bookingOperatorSlug}/${bookingOwner.username}`, bookingOwner.password);
});

test.afterAll(async () => {
  await page.close();
});

test("tổng quan: thẻ chỉ số + chuyến sắp chạy có chuyến đã bán của nhà xe", async () => {
  await page.getByRole("link", { name: "Tổng quan", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Tổng quan", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("7 ngày tới", { exact: true })).toBeVisible();
  const upcoming = page.getByRole("region", { name: "Chuyến sắp chạy" });
  await expect(upcoming.getByRole("link", { name: fixtures.routeName }).first()).toBeVisible(FIRST_VISIT);
});

test("báo cáo theo ngày khởi hành: doanh thu gộp, lấp đầy, dòng tuyến; xuất CSV", async () => {
  await page.getByRole("link", { name: "Báo cáo", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Báo cáo", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByLabel("Khởi hành từ").fill(fixtures.date);
  await page.getByLabel("Đến ngày").fill(fixtures.date);
  const route = page.getByRole("region", { name: "Theo tuyến" }).getByRole("row").filter({ hasText: fixtures.routeName });
  await expect(route).toContainText("600.000", FIRST_VISIT);
  await expect(route).toContainText("50,0%");
  await expect(page.getByText("2 / 4 chỗ")).toBeVisible();

  const download = page.waitForEvent("download");
  await page.getByRole("button", { name: "Xuất báo cáo" }).click();
  const file = await download;
  expect(file.suggestedFilename()).toBe(`bao-cao-${fixtures.date}-${fixtures.date}.csv`);
  const csv = await readFile((await file.path())!, "utf8");
  expect(csv).toContain(`"${fixtures.routeName}","1","0","4","2","50.0","600000"`);
});

test("đánh giá công khai: thẻ báo cáo tính điểm chuyến trong kỳ", async () => {
  const from = new Date(Date.now() + 7 * 3_600_000 - 15 * 86_400_000).toISOString().slice(0, 10);
  const to = new Date(Date.now() + 7 * 3_600_000).toISOString().slice(0, 10);
  await page.getByLabel("Khởi hành từ").fill(from);
  await page.getByLabel("Đến ngày").fill(to);
  const rating = page.getByText("Đánh giá của hành khách", { exact: true }).locator("..");
  await expect(rating).toContainText("4.0 / 5", FIRST_VISIT);
  await expect(rating).toContainText("1 đánh giá công khai");
});
