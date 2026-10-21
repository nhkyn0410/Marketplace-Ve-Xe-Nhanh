import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment } from "./helpers";

// Màn Hồ sơ & KYC của chủ nhà xe (TASK-OPR-001b, UC-11; Figma 1667:27240, 1667:27586): sửa thông tin công khai, tải
// bản mới của một giấy tờ KYC rồi mở xem, gửi yêu cầu đổi tài khoản nhận tiền (xác nhận lại danh tính bằng mật khẩu).
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
const PDF = Buffer.from("%PDF-1.7\n1 0 obj << >> endobj\ntrailer << >>\n%%EOF\n");
let page: Page;
let password: string;

test.beforeAll(async ({ browser }) => {
  const { kycOperatorSlug, kycOwner } = accounts();
  password = kycOwner.password;
  page = await browser.newPage();
  await signInWithEnrollment(page, `${kycOperatorSlug}/${kycOwner.username}`, password);
});

test.afterAll(async () => {
  await page.close();
});

test("xem hồ sơ: thông tin doanh nghiệp, trạng thái, tài khoản nhận tiền chỉ 4 số cuối; sửa thông tin công khai", async () => {
  const { kycOperatorSlug } = accounts();
  await page.getByRole("link", { name: "Hồ sơ & KYC", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Hồ sơ & KYC", level: 1 })).toBeVisible(FIRST_VISIT);
  const business = page.getByRole("region", { name: "Hồ sơ doanh nghiệp" });
  await expect(business).toContainText(kycOperatorSlug, FIRST_VISIT);
  await expect(business).toContainText("19006868");
  const bank = page.getByRole("region", { name: "Tài khoản nhận tiền" });
  await expect(bank).toContainText("Vietcombank");
  await expect(bank).toContainText("•••• 4521");
  await expect(bank).not.toContainText("0071000124521");
  await expect(page.getByRole("region", { name: "Trạng thái hoạt động" })).toContainText("Đang hoạt động");
  await expect(page.getByRole("button", { name: "Mở trang nhà xe" })).toBeDisabled();

  await business.getByRole("button", { name: "Chỉnh sửa" }).click();
  const dialog = page.getByRole("dialog", { name: "Chỉnh sửa hồ sơ doanh nghiệp" });
  await dialog.getByLabel("Hotline *").fill("12");
  await dialog.getByRole("button", { name: "Lưu thay đổi" }).click();
  await expect(dialog.getByText("Hotline gồm 8–15 chữ số.")).toBeVisible();
  await dialog.getByLabel("Hotline *").fill("1900 1234");
  await dialog.getByLabel("Mô tả").fill("Tuyến TP. Hồ Chí Minh – Đà Lạt, xe giường nằm.");
  await dialog.getByRole("button", { name: "Lưu thay đổi" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  await expect(page.getByRole("status")).toContainText("Đã lưu hồ sơ doanh nghiệp.");
  await expect(business).toContainText("19001234");
  await expect(business).toContainText("Tuyến TP. Hồ Chí Minh – Đà Lạt, xe giường nằm.");
});

test("giấy tờ KYC: tệp sai định dạng báo lỗi; tải bản mới PDF → hiện tên tệp, mở xem được", async () => {
  const kyc = page.getByRole("region", { name: "Giấy tờ KYC" });
  const row = kyc.getByRole("row").filter({ hasText: "Giấy phép kinh doanh vận tải" });
  await expect(row).toContainText("Chưa có tệp");

  await row.getByLabel("Chọn tệp Giấy phép kinh doanh vận tải").setInputFiles({ name: "ghi-chu.txt", mimeType: "text/plain", buffer: Buffer.from("x") });
  await expect(page.getByText("Định dạng không được hỗ trợ. Chọn PDF, JPEG hoặc PNG.")).toBeVisible();

  await row.getByLabel("Chọn tệp Giấy phép kinh doanh vận tải").setInputFiles({ name: "gpkd-van-tai.pdf", mimeType: "application/pdf", buffer: PDF });
  await expect(row).toContainText("gpkd-van-tai.pdf", { timeout: 20_000 });
  await expect(page.getByRole("status")).toContainText("Đã cập nhật giấy tờ gpkd-van-tai.pdf.");

  const popup = page.waitForEvent("popup");
  await row.getByRole("button", { name: "Xem Giấy phép kinh doanh vận tải" }).click();
  const tab = await popup;
  // Kho dev trả URL có token ký (khóa object nằm trong token); production là URL R2 có chữ ký.
  await expect.poll(() => tab.url(), { timeout: 20_000 }).toMatch(/download/);
  await tab.close();
});

test("đổi tài khoản nhận tiền: lỗi tại ô, sai mật khẩu báo tại ô, gửi xong thì chờ xác minh và khóa nút đổi", async () => {
  const bank = page.getByRole("region", { name: "Tài khoản nhận tiền" });
  await bank.getByRole("button", { name: "Đổi tài khoản nhận tiền" }).click();
  const dialog = page.getByRole("dialog", { name: "Đổi tài khoản nhận tiền" });
  await expect(dialog).toContainText("Tài khoản hiện tại: Vietcombank · •••• 4521");
  await dialog.getByRole("button", { name: "Gửi xác minh" }).click();
  await expect(dialog.getByText("Chọn ngân hàng.")).toBeVisible();
  await expect(dialog.getByText("Nhập lý do (3–500 ký tự).")).toBeVisible();
  await expect(dialog.getByText("Nhập mật khẩu của bạn hoặc mã xác thực 6 số.")).toBeVisible();

  await dialog.getByLabel("Ngân hàng *").click();
  await page.getByRole("option", { name: "Techcombank" }).click();
  await dialog.getByLabel("Số tài khoản *").fill("1903 6688 0011");
  await dialog.getByLabel("Tên chủ tài khoản *").fill("Công ty TNHH E2E");
  await dialog.getByLabel("Lý do đổi *").fill("Đổi sang tài khoản công ty mới");
  await dialog.getByLabel("Mật khẩu của bạn hoặc mã xác thực *").fill("sai-mat-khau-hoan-toan");
  await dialog.getByRole("button", { name: "Gửi xác minh" }).click();
  await expect(dialog.getByText("Mật khẩu hoặc mã xác thực không đúng.")).toBeVisible({ timeout: 20_000 });

  await dialog.getByLabel("Mật khẩu của bạn hoặc mã xác thực *").fill(password);
  await dialog.getByRole("button", { name: "Gửi xác minh" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  await expect(page.getByRole("status").first()).toContainText("Đã gửi yêu cầu đổi tài khoản.");
  await expect(bank).toContainText("Đang chờ xác minh: Techcombank · •••• 0011");
  await expect(bank).toContainText("Vietcombank");
  await expect(bank.getByRole("button", { name: "Đổi tài khoản nhận tiền" })).toBeDisabled();
});

test("mục Khuyến mãi (nhà xe chưa được cấp quyền) / Tài chính: không số liệu mẫu", async () => {
  await page.getByRole("link", { name: "Khuyến mãi", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Khuyến mãi", level: 1 })).toBeVisible({ timeout: 30_000 });
  // TASK-PROM-001: nhà xe này chưa được Vé Xe Nhanh cấp quyền tự tạo khuyến mãi (Figma "Nhà xe · Khuyến mãi" 03).
  await expect(page.getByText("Nhà xe chưa được cấp quyền tạo khuyến mãi")).toBeVisible({ timeout: 30_000 });
  await page.getByRole("link", { name: "Tài chính", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Tài chính", level: 1 })).toBeVisible({ timeout: 30_000 });
  await expect(page.getByText("Số dư đang giữ")).toBeVisible();
  await page.getByRole("navigation", { name: "Tài chính" }).getByRole("link", { name: "Chi trả" }).click();
  // Nhà xe chưa có chuyến nào hoàn thành → chưa có kỳ chi trả (không số liệu mẫu).
  await expect(page.getByText("Chưa có kỳ chi trả", { exact: true })).toBeVisible({ timeout: 30_000 });
});
