import { randomUUID } from "node:crypto";

import { expect, test, type Page } from "@playwright/test";

import { accounts, signInPlatform, totp } from "./helpers";

// Quản lý nhà xe + người dùng (Figma ADM-02e/f, ADM-03a…03d; FR-ADM-02/03, FR-IAM-08): tạm khóa / mở khóa nhà xe,
// khóa / mở khóa hành khách, xem nhân viên nhà xe, cấp tài khoản quản trị rồi khóa / mở khóa — thao tác thay đổi cần
// lý do + mã TOTP (xác nhận lại danh tính 5 phút).
test.describe.configure({ mode: "serial" });

const tag = randomUUID().replace(/-/g, "").slice(0, 6);
let page: Page;
let secret = "";

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
});

test.afterAll(async () => {
  await page.close();
});

test("nhà xe: tạm khóa cần lý do + TOTP → Tạm khóa kèm lý do; mở khóa → Đang hoạt động", async () => {
  const { operatorName, operatorSlug } = accounts().adminUsers;
  secret = await signInPlatform(page, accounts().platformUsers);
  await page.getByRole("link", { name: "Nhà xe & KYC", exact: true }).click();
  await page.getByRole("tab", { name: "Nhà xe" }).click();
  await page.getByRole("searchbox", { name: "Tìm nhà xe" }).fill(operatorSlug);
  const row = page.getByRole("row").filter({ hasText: operatorSlug });
  await expect(row).toContainText("Đang hoạt động", { timeout: 20_000 });
  await expect(row).toContainText(`${operatorSlug}/owner01`);

  await row.getByRole("button", { name: `Tạm khóa nhà xe ${operatorName}` }).click();
  const dialog = page.getByRole("dialog", { name: "Tạm khóa nhà xe" });
  await dialog.getByRole("button", { name: "Tạm khóa nhà xe" }).click();
  await expect(dialog.getByText("Nhập lý do (ít nhất 3 ký tự).")).toBeVisible();
  await dialog.getByLabel("Lý do *").fill("Vi phạm chất lượng dịch vụ");
  await dialog.getByLabel("Mã xác thực (TOTP) *").fill(totp(secret, Date.now() + 30_000));
  await dialog.getByRole("button", { name: "Tạm khóa nhà xe" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  await expect(row).toContainText("Tạm khóa");
  await expect(row).toContainText("Vi phạm chất lượng dịch vụ");
  await expect(row).toContainText("Không mở bán");

  // Vừa xác nhận danh tính: 5 phút tới không phải nhập lại mã.
  await row.getByRole("button", { name: `Mở khóa nhà xe ${operatorName}` }).click();
  const unlock = page.getByRole("dialog", { name: "Mở khóa nhà xe" });
  await expect(unlock.getByLabel("Mã xác thực (TOTP) *")).toHaveCount(0);
  await unlock.getByRole("button", { name: "Mở khóa" }).click();
  await expect(unlock).toBeHidden({ timeout: 20_000 });
  await expect(row).toContainText("Đang hoạt động");
});

test("hành khách: khóa kèm lý do → Bị khóa; mở khóa; nhân viên nhà xe chỉ xem", async () => {
  const { passengerEmail } = accounts().adminUsers;
  await page.getByRole("link", { name: "Người dùng", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Người dùng" })).toBeVisible({ timeout: 20_000 });
  await page.getByRole("searchbox", { name: "Tìm hành khách" }).fill(passengerEmail);
  const row = page.getByRole("row").filter({ hasText: passengerEmail });
  await expect(row).toContainText("Hoạt động");
  await expect(row).toContainText("Email OTP");
  await row.getByRole("button", { name: `Khóa ${passengerEmail}` }).click();
  const dialog = page.getByRole("dialog", { name: "Khóa tài khoản hành khách" });
  await dialog.getByLabel("Lý do *").fill("Nghi gian lận thanh toán");
  await dialog.getByRole("button", { name: "Khóa tài khoản" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  await expect(row).toContainText("Bị khóa");
  await expect(row).toContainText("Nghi gian lận thanh toán");
  await row.getByRole("button", { name: `Mở khóa ${passengerEmail}` }).click();
  await page.getByRole("dialog", { name: "Mở khóa tài khoản hành khách" }).getByRole("button", { name: "Mở khóa" }).click();
  await expect(row).toContainText("Hoạt động");

  await page.getByRole("tab", { name: "Nhân viên nhà xe" }).click();
  await page.getByRole("searchbox", { name: "Tìm nhân viên" }).fill(accounts().employee.username);
  const employee = page.getByRole("row").filter({ hasText: accounts().employee.username });
  await expect(employee).toContainText("Tài xế");
  await expect(employee.getByRole("button")).toHaveCount(0);
});

test("tài khoản quản trị: tên sai báo tại ô; cấp mới (email chưa cấu hình → chờ gửi mật khẩu); khóa / mở khóa; không tự khóa mình", async () => {
  await page.getByRole("tab", { name: "Tài khoản quản trị" }).click();
  const self = page.getByRole("row").filter({ hasText: `platform/${accounts().platformUsers.username}` });
  await expect(self).toContainText("(bạn)", { timeout: 20_000 });
  await expect(self).toContainText("Đang bật");
  await expect(self.getByRole("button")).toHaveCount(0);

  await page.getByRole("button", { name: "Thêm tài khoản quản trị" }).click();
  const dialog = page.getByRole("dialog", { name: "Thêm tài khoản quản trị" });
  await dialog.getByLabel("Tên đăng nhập *").fill("ab");
  await dialog.getByLabel("Email nội bộ *").fill(`moi-${tag}@vexenhanh.test`);
  await dialog.getByRole("button", { name: "Tạo tài khoản" }).click();
  await expect(dialog.getByText(/Tên đăng nhập gồm 3–40 ký tự/)).toBeVisible();
  await dialog.getByLabel("Tên đăng nhập *").fill(`e2e.moi.${tag}`);
  await dialog.getByLabel("Hỗ trợ nền tảng").check();
  await dialog.getByRole("button", { name: "Tạo tài khoản" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  const created = page.getByRole("row").filter({ hasText: `platform/e2e.moi.${tag}` });
  await expect(created).toContainText("Hỗ trợ nền tảng");
  await expect(created).toContainText("Chưa thiết lập");
  await expect(page.getByRole("status")).toContainText(/Đã tạo platform\/e2e\.moi\./);

  await created.getByRole("button", { name: `Khóa platform/e2e.moi.${tag}` }).click();
  const lock = page.getByRole("dialog", { name: "Khóa tài khoản quản trị" });
  await lock.getByLabel("Lý do *").fill("Tài khoản thử nghiệm E2E");
  await lock.getByRole("button", { name: "Khóa tài khoản" }).click();
  await expect(lock).toBeHidden({ timeout: 20_000 });
  await expect(created).toContainText("Bị khóa");
  await created.getByRole("button", { name: `Mở khóa platform/e2e.moi.${tag}` }).click();
  await page.getByRole("dialog", { name: "Mở khóa tài khoản quản trị" }).getByRole("button", { name: "Mở khóa" }).click();
  await expect(created).toContainText("Hoạt động");
});

test("nhà xe đổi tài khoản nhận tiền: xem số đầy đủ để đối chiếu; từ chối cần lý do; xác minh → hết chờ", async () => {
  const { operatorName, operatorSlug } = accounts().adminUsers;
  await page.getByRole("link", { name: "Nhà xe & KYC", exact: true }).click();
  await page.getByRole("tab", { name: "Nhà xe" }).click();
  await page.getByRole("searchbox", { name: "Tìm nhà xe" }).fill(operatorSlug);
  const row = page.getByRole("row").filter({ hasText: operatorSlug });
  await row.getByRole("button", { name: `Xác minh tài khoản nhận tiền của ${operatorName}` }).click({ timeout: 20_000 });
  const dialog = page.getByRole("dialog", { name: "Xác minh tài khoản nhận tiền" });
  await expect(dialog.getByRole("region", { name: "Tài khoản đang dùng" })).toContainText("0071000124521", { timeout: 20_000 });
  await expect(dialog.getByRole("region", { name: "Tài khoản mới" })).toContainText("190366880011");
  await expect(dialog).toContainText("Đổi sang tài khoản công ty mới");

  await dialog.getByRole("button", { name: "Từ chối" }).click();
  await expect(dialog.getByText("Nhập lý do (ít nhất 3 ký tự).")).toBeVisible();
  const code = dialog.getByLabel("Mã xác thực (TOTP) *");
  if (await code.isVisible()) {
    await code.fill(totp(secret, Date.now() + 30_000));
  }
  await dialog.getByRole("button", { name: "Xác minh" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  await expect(page.getByRole("status")).toContainText(`Đã xác minh tài khoản nhận tiền mới của ${operatorName}.`);
  await expect(row.getByRole("button", { name: `Xác minh tài khoản nhận tiền của ${operatorName}` })).toHaveCount(0);
});
