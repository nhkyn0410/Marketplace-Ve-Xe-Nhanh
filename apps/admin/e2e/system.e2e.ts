import { expect, test, type Page } from "@playwright/test";

import { accounts, signInPlatform } from "./helpers";

test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
  await signInPlatform(page, accounts().platform);
});

test.afterAll(async () => {
  await page.close();
});

test("tác vụ nền: tải lịch sử đối soát và yêu cầu lý do trước khi chạy thủ công", async () => {
  await page.goto("/system?tab=jobs");
  const panel = page.getByRole("region", { name: "Đối soát thanh toán và sổ giữ hộ" });
  await expect(panel).toBeVisible(FIRST_VISIT);
  await expect(panel.getByRole("status")).toHaveCount(0, FIRST_VISIT);
  await expect(panel.getByRole("alert")).toHaveCount(0);
  const run = panel.getByRole("button", { name: "Chạy lại đối soát" });
  if (await run.isEnabled()) {
    await run.click();
    const dialog = page.getByRole("dialog");
    await dialog.getByRole("button", { name: "Chạy đối soát", exact: true }).click();
    await expect(dialog.getByRole("alert")).toContainText("Nhập lý do 3–500 ký tự.");
    await dialog.getByRole("button", { name: "Hủy", exact: true }).click();
    await expect(dialog).toBeHidden();
  } else {
    await expect(panel).toContainText(/Đang chờ|Đang đối soát/);
  }
});

test("nhật ký thông báo: đọc kết quả gửi, điều hướng tab và làm mới được", async () => {
  const loaded = page.waitForResponse((response) => response.url().includes("/admin/system/notifications?") && response.request().method() === "GET");
  await page.getByRole("tab", { name: "Nhật ký thông báo" }).click();
  expect((await loaded).status()).toBe(200);
  const panel = page.getByRole("region", { name: "Nhật ký gửi thông báo" });
  await expect(panel).toBeVisible(FIRST_VISIT);
  await expect(panel.getByRole("alert")).toHaveCount(0);
  await expect(panel.getByRole("button", { name: "Trang trước" })).toBeDisabled();
  const refreshed = page.waitForResponse((response) => response.url().includes("/admin/system/notifications?") && response.request().method() === "GET");
  await page.getByRole("button", { name: "Kiểm tra lại" }).click();
  expect((await refreshed).status()).toBe(200);
  await expect(page).toHaveURL(/\/system\?tab=notifications$/);
});
