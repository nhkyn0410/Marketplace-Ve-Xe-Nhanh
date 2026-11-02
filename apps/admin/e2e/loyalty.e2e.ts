import { expect, test, type Locator, type Page } from "@playwright/test";

import { accounts, signInPlatform, totp } from "./helpers";

// TASK-LOY-001 (VXN Plus, Figma ADM-12a…12d) — chính sách v1 do migration seed; global-setup seed một hành khách có sổ điểm 350 (tích
// 300 + điều chỉnh 50). Tab chính sách chỉ kiểm lỗi tại chỗ: chính sách VXN Plus dùng chung toàn nền tảng, lưu nháp / kích hoạt sẽ đổi
// dữ liệu của mọi lần chạy sau (luồng kích hoạt chung đã kiểm ở `policies.e2e.ts`). Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let secret = "";

/** Điền mã TOTP nếu ô đang hiện (5 phút sau lần xác nhận trước thì không hỏi lại). */
async function fillTotpIfAsked(scope: Locator) {
  const code = scope.getByLabel("Mã xác thực (TOTP) *");
  if (await code.isVisible()) {
    await code.fill(totp(secret, Date.now() + 30_000));
  }
}

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
  secret = await signInPlatform(page, accounts().platformLoyalty);
});

test.afterAll(async () => {
  await page.close();
});

test("chính sách chương trình: phiên bản đang áp dụng điền sẵn số liệu Figma; mốc hạng không tăng / thiếu hiệu lực + lý do → báo tại ô", async () => {
  await page.getByRole("link", { name: "VXN Plus", exact: true }).click();
  await expect(page.getByRole("heading", { name: "VXN Plus", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText(/Đang áp dụng phiên bản \d+ từ/)).toBeVisible(FIRST_VISIT);
  await expect(page.getByLabel("Đơn vị tích điểm (₫ cho 1 điểm) *")).toHaveValue("10.000");
  await expect(page.getByLabel("Giá trị quy đổi (₫ mỗi điểm) *")).toHaveValue("1.000");
  await expect(page.getByLabel("Số điểm đổi tối thiểu *")).toHaveValue("100");
  const minPoints = page.getByLabel("Từ (điểm tích trong 12 tháng) *");
  const multipliers = page.getByLabel("Hệ số tích điểm *");
  await expect(minPoints.nth(0)).toHaveValue("0");
  await expect(minPoints.nth(1)).toHaveValue("2000");
  await expect(multipliers.nth(1)).toHaveValue("1,2");
  await expect(multipliers.nth(3)).toHaveValue("2");
  await expect(page.getByRole("region", { name: "Lịch sử phiên bản" })).toContainText("Đang áp dụng");

  await minPoints.nth(2).fill("1500");
  await multipliers.nth(2).fill("1,1");
  await page.getByRole("button", { name: "Kích hoạt phiên bản" }).click();
  await expect(page.getByText("Phải lớn hơn mốc của hạng dưới.")).toBeVisible();
  await expect(page.getByText("Không thấp hơn hệ số hạng dưới.")).toBeVisible();
  await expect(page.getByText("Chọn thời điểm hiệu lực ở tương lai.")).toBeVisible();
  await expect(page.getByText("Nhập lý do (ít nhất 3 ký tự).")).toBeVisible();
});

test("tài khoản thành viên: email không có → báo; tra cứu → hạng, điểm, sổ điểm; trừ quá số dư bị chặn; cộng 25 (lý do + TOTP) → 375", async () => {
  const { passengerEmail, passengerName } = accounts().loyalty;
  await page.getByRole("tab", { name: "Điểm thành viên" }).click();
  const email = page.getByLabel("Tra cứu hành khách");
  await email.fill(`khong-co-${passengerEmail}`);
  await page.getByRole("button", { name: "Tra cứu" }).click();
  await expect(page.getByText("Không tìm thấy hành khách", { exact: true })).toBeVisible(FIRST_VISIT);

  await email.fill(passengerEmail.toUpperCase());
  await page.getByRole("button", { name: "Tra cứu" }).click();
  const card = page.getByRole("region", { name: "Tài khoản thành viên" });
  await expect(card).toContainText(passengerName, FIRST_VISIT);
  await expect(card).toContainText("Hạng Đồng");
  await expect(card).toContainText("350");
  const history = page.getByRole("region", { name: "Lịch sử giao dịch điểm" });
  const rows = history.getByRole("row");
  await expect(rows.nth(1)).toContainText("Điều chỉnh");
  await expect(rows.nth(1)).toContainText("+50");
  await expect(rows.nth(2)).toContainText("Tích điểm");
  await expect(rows.nth(2)).toContainText("+300");
  await expect(rows.nth(2)).toContainText("Phiên bản 1");

  await card.getByRole("button", { name: "Điều chỉnh điểm" }).click();
  const dialog = page.getByRole("dialog", { name: "Điều chỉnh điểm" });
  await dialog.getByRole("radio", { name: /Trừ điểm/ }).click();
  await dialog.getByLabel("Số điểm *").fill("1000");
  await dialog.getByLabel("Lý do *").fill("Thử trừ quá số dư");
  await dialog.getByRole("button", { name: "Xác nhận điều chỉnh" }).click();
  await expect(dialog.getByText("Không trừ quá điểm khả dụng (350).")).toBeVisible();

  await dialog.getByRole("radio", { name: /Cộng điểm/ }).click();
  await dialog.getByLabel("Số điểm *").fill("25");
  await expect(dialog).toContainText("375");
  await dialog.getByLabel("Lý do *").fill("Bù sự cố chuyến E2E");
  await fillTotpIfAsked(dialog);
  await dialog.getByRole("button", { name: "Xác nhận điều chỉnh" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã cộng 25 điểm" })).toBeVisible(FIRST_VISIT);
  await expect(dialog).toBeHidden();
  await expect(card).toContainText("375");
  await expect(rows.nth(1)).toContainText("+25", FIRST_VISIT);
  await expect(rows.nth(1)).toContainText("Bù sự cố chuyến E2E");
});

test("báo cáo: quý hiện tại có tháng này; lọc hạng Bạc; xuất CSV", async () => {
  await page.getByRole("tab", { name: "Báo cáo" }).click();
  const local = new Date(Date.now() + 7 * 3_600_000);
  const table = page.getByRole("region", { name: "Báo cáo theo kỳ" });
  await expect(table.getByRole("rowheader", { name: `Tháng ${local.getUTCMonth() + 1}/${local.getUTCFullYear()}` })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText(`Quý ${Math.floor(local.getUTCMonth() / 3) + 1}/${local.getUTCFullYear()}`).first()).toBeVisible();
  await page.getByLabel("Hạng thành viên").click();
  await page.getByRole("option", { name: "Bạc", exact: true }).click();
  await expect(page.getByLabel("Hạng thành viên")).toContainText("Bạc");
  const download = page.waitForEvent("download");
  await page.getByRole("button", { name: "Xuất báo cáo" }).click();
  expect((await download).suggestedFilename()).toMatch(/^vxn-plus-quy-\d-\d{4}-silver\.csv$/);
});
