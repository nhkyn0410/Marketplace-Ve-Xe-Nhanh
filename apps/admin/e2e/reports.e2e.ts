import { readFile } from "node:fs/promises";

import { expect, test, type Page } from "@playwright/test";

import { accounts, signInPlatform } from "./helpers";

// TASK-RPT-002 (Tổng quan ADM-01 + Báo cáo ADM-14a) — nhà xe đặt vé do global-setup seed có thanh toán thành công trong 7 ngày gần
// nhất (vé + sổ giữ hộ) và kỳ chi trả chờ rà soát. Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;

test.beforeAll(async ({ browser }) => {
  const { bookingFixtures, platformReports } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Báo cáo (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  await signInPlatform(page, platformReports);
});

test.afterAll(async () => {
  await page.close();
});

async function pickOperator() {
  await page.getByRole("combobox", { name: "Nhà xe" }).click();
  await page.getByRole("option", { name: fixtures.operatorName, exact: true }).click();
}

test("tổng quan lọc theo nhà xe: tiền đang giữ, biểu đồ theo ngày, hàng đợi chi trả + đối soát có số", async () => {
  await page.getByRole("link", { name: "Tổng quan", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Tổng quan nền tảng", level: 1 })).toBeVisible(FIRST_VISIT);
  await pickOperator();
  const queue = page.getByRole("region", { name: "Việc cần xử lý" });
  // Số kỳ chờ rà soát tùy payouts.e2e đã chạy chưa — chỉ kiểm hàng đợi có số thật.
  await expect(queue.getByRole("link", { name: /Chi trả chờ rà soát\s*Kỳ chi trả đã tạo, chờ Admin duyệt\s*\d+/ })).toBeVisible(FIRST_VISIT);
  await expect(queue.getByRole("link", { name: /Thanh toán cần đối soát/ })).toBeVisible();
  await expect(page.getByRole("region", { name: "Tiền đang giữ (escrow)" })).toContainText("Đủ điều kiện chi trả");
  await expect(page.getByRole("region", { name: "Giá trị giao dịch theo ngày" }).getByRole("list", { name: "Giá trị giao dịch theo ngày" })).toBeVisible();
});

test("báo cáo: dòng nhà xe, phương thức VNPay; xuất CSV theo nhà xe", async () => {
  await page.getByRole("link", { name: "Báo cáo", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Báo cáo", level: 1 })).toBeVisible(FIRST_VISIT);
  await pickOperator();
  const row = page.getByRole("region", { name: "Theo nhà xe" }).getByRole("row").filter({ hasText: fixtures.operatorName });
  await expect(row).toContainText("₫", FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Phương thức thanh toán" })).toContainText("VNPay");

  const download = page.waitForEvent("download");
  await page.getByRole("button", { name: "Xuất báo cáo" }).click();
  const file = await download;
  expect(file.suggestedFilename()).toMatch(/^bao-cao-he-thong-\d{4}-\d{2}-\d{2}-\d{4}-\d{2}-\d{2}\.csv$/);
  expect(await readFile((await file.path())!, "utf8")).toContain(`"${fixtures.operatorName}"`);
});
