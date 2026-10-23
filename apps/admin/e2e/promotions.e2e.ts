import { expect, test, type Page } from "@playwright/test";

import { accounts, signInPlatform } from "./helpers";

// TASK-PROM-001 (Khuyến mãi, Figma ADM-11a/b) — nhà xe đặt vé do global-setup seed đã được cấp quyền tự tạo khuyến mãi. Chạy tuần tự,
// dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;
const code = `E2EADM${Date.now().toString(36).toUpperCase().slice(-6)}`;

test.beforeAll(async ({ browser }) => {
  const { bookingFixtures, platformPromo } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Khuyến mãi (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  await signInPlatform(page, platformPromo);
});

test.afterAll(async () => {
  await page.close();
});

test("khuyến mãi nền tảng: tạo (mã sai báo tại ô) → lưu nháp → kích hoạt → Đang chạy; tạm dừng", async () => {
  await page.getByRole("link", { name: "Khuyến mãi", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Khuyến mãi", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Khuyến mãi nền tảng" })).toBeVisible(FIRST_VISIT);
  await page.getByRole("link", { name: "Tạo khuyến mãi" }).click();
  await expect(page.getByRole("heading", { name: "Tạo khuyến mãi", level: 1 })).toBeVisible(FIRST_VISIT);

  await page.getByLabel("Tên chương trình *").fill("Chào bạn mới E2E");
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Mã gồm 3–20 chữ / số, không dấu, không khoảng trắng.")).toBeVisible();
  await page.getByLabel("Mã khuyến mãi *").fill(code.toLowerCase());
  await expect(page.getByLabel("Mã khuyến mãi *")).toHaveValue(code);
  await page.getByText("Giảm số tiền cố định", { exact: true }).click();
  await page.getByLabel("Số tiền giảm (₫) *").fill("30000");
  await page.getByLabel("Giá trị đơn tối thiểu (₫)").fill("200000");
  const route = page.getByRole("checkbox", { name: new RegExp(fixtures.operatorName) }).first();
  await expect(route).toBeVisible(FIRST_VISIT);
  const routeLabel = await route.locator("..").innerText();
  await route.check();
  await expect(page.getByRole("region", { name: "Hành khách sẽ thấy" })).toContainText(`${code} · 30.000 ₫`);
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page).toHaveURL(/\/promotions\/[0-9a-f-]{36}/, FIRST_VISIT);
  await expect(page.getByRole("heading", { name: code, level: 1 })).toBeVisible();
  await expect(page.getByText("Nháp", { exact: true })).toBeVisible();
  await page.reload();
  await expect(page.getByRole("checkbox", { name: routeLabel.trim(), exact: true })).toBeChecked(FIRST_VISIT);

  await page.getByRole("button", { name: "Kích hoạt" }).click();
  await expect(page.getByRole("status")).toContainText("kích hoạt", FIRST_VISIT);
  await expect(page.getByText("Đang chạy", { exact: true })).toBeVisible();
  await page.getByRole("button", { name: "Tạm dừng" }).click();
  await expect(page.getByText("Tạm dừng", { exact: true }).first()).toBeVisible(FIRST_VISIT);

  await page.getByRole("link", { name: "Quay lại danh sách khuyến mãi" }).click();
  const list = page.getByRole("region", { name: "Khuyến mãi nền tảng" });
  await list.getByLabel("Tìm kiếm").fill(code);
  await expect(list.getByRole("row").filter({ hasText: code })).toContainText("Tạm dừng", FIRST_VISIT);
});

test("quyền của nhà xe: thấy giới hạn đã cấp; sửa mức giảm tối đa → lưu", async () => {
  await page.getByRole("tab", { name: "Quyền của nhà xe" }).click();
  const list = page.getByRole("region", { name: "Quyền của nhà xe" });
  await list.getByLabel("Tìm kiếm").fill(fixtures.operatorName);
  const row = list.getByRole("row").filter({ hasText: fixtures.operatorName });
  await expect(row).toContainText("20% hoặc 100.000 ₫", FIRST_VISIT);
  await row.getByRole("button", { name: `Sửa quyền ${fixtures.operatorName}` }).click();
  const dialog = page.getByRole("dialog");
  await dialog.getByLabel("Mức giảm tối đa (%)").fill("15");
  await dialog.getByRole("button", { name: "Lưu quyền" }).click();
  await expect(dialog).toBeHidden(FIRST_VISIT);
  await expect(row).toContainText("15% hoặc 100.000 ₫");
});
