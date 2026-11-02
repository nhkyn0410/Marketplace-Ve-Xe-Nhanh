import { expect, test, type Page } from "@playwright/test";

import { signInPlatform } from "./helpers";

// TASK-NSR-003 (Chiến dịch thông báo, chờ duyệt). Worker phải chạy để chiến dịch chuyển sang Đã gửi. Chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
const tag = Date.now().toString(36).toUpperCase().slice(-6);
let page: Page;

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
  await signInPlatform(page);
});

test.afterAll(async () => {
  await page.close();
});

async function openNewDraft(title: string): Promise<void> {
  await page.goto("/notifications/new");
  await expect(page.getByRole("heading", { name: "Tạo thông báo", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByLabel("Tiêu đề").fill(title);
  await page.getByLabel("Nội dung", { exact: true }).fill("Hệ thống sẽ bảo trì từ 1 giờ đến 2 giờ sáng.");
  await expect(page.getByRole("region", { name: "Khách sẽ thấy" })).toContainText(title);
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page).toHaveURL(/\/notifications\/[0-9a-f-]{36}/, FIRST_VISIT);
  await expect(page.getByRole("heading", { name: "Bản nháp thông báo", level: 1 })).toBeVisible(FIRST_VISIT);
}

test("thông báo dịch vụ: lưu nháp → xác nhận có số người nhận → gửi → xem kết quả, không gửi email hàng loạt", async () => {
  await page.goto("/");
  await page.getByRole("link", { name: "Thông báo", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Thông báo", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("note")).toContainText("không gửi email hàng loạt");
  await page.getByRole("link", { name: "Tạo thông báo" }).click();
  await expect(page.getByRole("heading", { name: "Tạo thông báo", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("button", { name: "Lưu nháp" })).toBeDisabled();

  // Dịch vụ luôn gửi mọi tài khoản nên không có lựa chọn đối tượng.
  await expect(page.getByRole("group", { name: "Đối tượng" })).toHaveCount(0);
  const reach = page.getByRole("region", { name: "Người nhận" });
  await expect(reach).toContainText("Vào hộp thư", FIRST_VISIT);

  const title = `Bảo trì ${tag}`;
  await openNewDraft(title);

  // Chưa lưu thì chưa gửi được.
  await page.getByLabel("Tiêu đề").fill(`${title} sửa `);
  await expect(page.getByRole("button", { name: "Gửi", exact: true })).toBeDisabled();
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Đã lưu bản nháp.", { exact: true })).toBeVisible(FIRST_VISIT);
  await expect(page.getByLabel("Tiêu đề")).toHaveValue(`${title} sửa`);

  await page.getByRole("button", { name: "Gửi", exact: true }).click();
  const dialog = page.getByRole("dialog");
  await expect(dialog).toContainText(/Khoảng [\d.]+ hành khách sẽ nhận/);
  await dialog.getByRole("button", { name: "Gửi ngay" }).click();

  await expect(page.getByRole("heading", { name: `${title} sửa`, level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("Đã gửi", { exact: true })).toBeVisible({ timeout: 60_000 });
  const result = page.getByRole("region", { name: "Kết quả gửi" });
  await expect(result).toContainText("Đã vào hộp thư");

  await page.goto("/notifications");
  await expect(page.getByRole("row", { name: new RegExp(`${title} sửa`) })).toContainText("Đã gửi", FIRST_VISIT);
});

test("hẹn giờ rồi hủy; khuyến mãi bắt buộc chọn chương trình và có chọn đối tượng", async () => {
  await openNewDraft(`Hẹn giờ ${tag}`);
  await page.getByRole("button", { name: "Gửi", exact: true }).click();
  const dialog = page.getByRole("dialog");
  await dialog.getByRole("radio", { name: "Hẹn giờ" }).check();
  await expect(dialog.getByRole("button", { name: "Hẹn giờ gửi" })).toBeDisabled();
  const later = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
  const pad = (value: number) => String(value).padStart(2, "0");
  await dialog.getByLabel("Thời điểm gửi").fill(`${later.getFullYear()}-${pad(later.getMonth() + 1)}-${pad(later.getDate())}T10:00`);
  await dialog.getByRole("button", { name: "Hẹn giờ gửi" }).click();
  await expect(page.getByText("Đã hẹn giờ", { exact: true })).toBeVisible(FIRST_VISIT);
  await page.getByRole("button", { name: "Hủy hẹn giờ" }).click();
  await expect(page.getByText("Đã hủy", { exact: true }).first()).toBeVisible(FIRST_VISIT);

  await page.goto("/notifications/new");
  await expect(page.getByRole("heading", { name: "Tạo thông báo", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByRole("radio", { name: /Khuyến mãi/ }).check();
  await page.getByLabel("Tiêu đề").fill(`Ưu đãi ${tag}`);
  await page.getByLabel("Nội dung", { exact: true }).fill("Giảm giá cuối tuần cho khách đã bật nhận ưu đãi.");
  await expect(page.getByRole("button", { name: "Lưu nháp" })).toBeDisabled();
  await expect(page.getByRole("group", { name: "Đối tượng" })).toBeVisible();
  await page.getByRole("radio", { name: "Theo hạng VXN Plus" }).check();
  await expect(page.getByRole("region", { name: "Người nhận" })).toContainText("Chọn ít nhất một hạng");
  await page.getByRole("checkbox", { name: "Vàng" }).check();
  await expect(page.getByRole("region", { name: "Người nhận" })).toContainText("Đã nhận khuyến mãi trong 24 giờ", FIRST_VISIT);
});
