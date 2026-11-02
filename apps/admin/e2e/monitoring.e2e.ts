import { expect, test, type Page } from "@playwright/test";

import { accounts, signInPlatform } from "./helpers";

// Admin giám sát (tự thiết kế 28/10/2026, chờ duyệt): Tuyến & chuyến (tuyến + chi tiết có điểm dừng / chuyến sắp chạy, chuyến
// + danh sách người đi), chi tiết nhà xe (tab Tuyến / Đội xe), chi tiết tài khoản hành khách → sổ điểm VXN Plus, báo cáo theo
// tuyến. Dữ liệu: nhà xe đặt vé + hành khách VXN Plus của global-setup. Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
const ROUTE_NAME = "E2E Sài Gòn – Đà Lạt (đặt vé)";
let page: Page;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;

test.beforeAll(async ({ browser }) => {
  const { bookingFixtures } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền nhà xe đặt vé (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  await signInPlatform(page);
});

test.afterAll(async () => {
  await page.close();
});

async function pickOperator(name: string) {
  await page.getByRole("combobox", { name: "Nhà xe" }).click();
  await page.getByRole("option", { name, exact: true }).click();
}

test("Tuyến & chuyến: lọc nhà xe → tuyến; chi tiết tuyến có điểm dừng + chuyến sắp chạy → chi tiết chuyến có danh sách người đi", async () => {
  await page.getByRole("link", { name: "Tuyến & chuyến" }).click();
  await expect(page.getByRole("heading", { name: "Tuyến & chuyến", level: 1 })).toBeVisible(FIRST_VISIT);
  await pickOperator(fixtures.operatorName);
  const routes = page.getByRole("region", { name: "Danh sách tuyến" });
  await expect(routes.getByRole("link", { name: ROUTE_NAME })).toBeVisible(FIRST_VISIT);
  await routes.getByRole("link", { name: ROUTE_NAME }).click();

  await expect(page.getByRole("heading", { name: ROUTE_NAME, level: 1 })).toBeVisible(FIRST_VISIT);
  // Tuyến seed không khai điểm dừng (chỉ chuyến có) → khối Điểm dừng báo trống.
  await expect(page.getByRole("region", { name: "Điểm dừng" })).toContainText("Tuyến chưa có điểm dừng.");
  const upcoming = page.getByRole("region", { name: "Chuyến sắp chạy" });
  await upcoming.getByRole("link").first().click();

  await expect(page.getByRole("heading", { name: `${ROUTE_NAME} · `, level: 1 })).toBeVisible(FIRST_VISIT);
  const manifest = page.getByRole("region", { name: "Danh sách người đi" });
  await expect(manifest.getByRole("row").nth(1)).toBeVisible(FIRST_VISIT);
  await expect(manifest).toContainText("Khách vãng lai");
  await expect(page.getByRole("region", { name: "Lịch trình" })).toContainText("E2E Bến xe Miền Đông mới");

  await page.getByRole("link", { name: "Quay lại danh sách chuyến" }).click();
  await expect(page.getByRole("tab", { name: "Chuyến xe" })).toHaveAttribute("aria-selected", "true", FIRST_VISIT);
});

test("chi tiết nhà xe: bấm tên ở danh sách → thẻ số, tab Tuyến có tuyến của nhà xe, tab Đội xe có xe", async () => {
  await page.getByRole("link", { name: "Nhà xe & KYC" }).click();
  await page.getByRole("tab", { name: "Nhà xe" }).click();
  const list = page.getByRole("region", { name: "Danh sách nhà xe" });
  await list.getByRole("searchbox").fill(fixtures.operatorName);
  await list.getByRole("link", { name: fixtures.operatorName }).click();

  await expect(page.getByRole("heading", { name: fixtures.operatorName, level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("30 ngày gần nhất")).toBeVisible();
  await page.getByRole("tab", { name: /^Tuyến/ }).click();
  await expect(page.getByRole("region", { name: "Danh sách tuyến" }).getByRole("link", { name: ROUTE_NAME })).toBeVisible(FIRST_VISIT);
  await page.getByRole("tab", { name: /^Đội xe/ }).click();
  await expect(page.getByRole("region", { name: "Đội xe" }).getByRole("row")).not.toHaveCount(0, FIRST_VISIT);
});

test("tài khoản hành khách: bấm tên → chi tiết có điểm VXN Plus → Mở sổ điểm sang tab Điểm thành viên", async () => {
  const { loyalty } = accounts();
  await page.getByRole("link", { name: "Người dùng" }).click();
  await expect(page.getByRole("tab", { name: "Tài khoản hành khách" })).toBeVisible(FIRST_VISIT);
  const list = page.getByRole("region", { name: "Danh sách hành khách" });
  await list.getByRole("searchbox").fill(loyalty.passengerEmail);
  await list.getByRole("link", { name: loyalty.passengerName }).click();

  await expect(page.getByRole("heading", { name: loyalty.passengerName, level: 1 })).toBeVisible(FIRST_VISIT);
  const plus = page.getByRole("region", { name: "VXN Plus" });
  await expect(plus).toContainText("điểm khả dụng");
  await expect(page.getByRole("region", { name: "Đơn đặt vé" })).toBeVisible();
  await plus.getByRole("link", { name: "Mở sổ điểm" }).click();

  await expect(page.getByRole("tab", { name: "Điểm thành viên" })).toHaveAttribute("aria-selected", "true", FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Tài khoản thành viên" })).toContainText(loyalty.passengerEmail, FIRST_VISIT);
  await page.getByRole("link", { name: "Xem hồ sơ hành khách" }).click();
  await expect(page.getByRole("heading", { name: loyalty.passengerName, level: 1 })).toBeVisible(FIRST_VISIT);
});

test("báo cáo: khối Theo tuyến + Theo khu vực, ô chọn kiểu tệp xuất", async () => {
  await page.getByRole("link", { name: "Báo cáo" }).click();
  await expect(page.getByRole("heading", { name: "Báo cáo", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Theo tuyến" })).toBeVisible();
  await expect(page.getByRole("region", { name: "Theo khu vực" })).toBeVisible();
  await expect(page.getByRole("combobox", { name: "Kiểu tệp xuất" })).toBeVisible();
});
