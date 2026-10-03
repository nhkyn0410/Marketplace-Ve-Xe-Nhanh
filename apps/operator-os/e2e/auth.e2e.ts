import { expect, test, type Page } from "@playwright/test";

import { accounts, totp } from "./helpers";

// TC-SEC-008 (08 Test) phía Operator OS: first-login Owner → TOTP → backup code → reload giữ phiên;
// access hết hạn → refresh một lần; Employee bị chặn (06 UI §7, TASK-IAM-006 Q4). Chạy tuần tự vì
// các ca sau dùng lại Owner đã enrollment ở ca đầu. Giao diện theo Figma "Giao diện nhà xe"; nút đăng
// xuất trong shell chưa làm nên chưa có ca đăng xuất qua giao diện (API logout có test riêng).
test.describe.configure({ mode: "serial" });

const API = "http://localhost:3000/v1";
let backupCodes: string[] = [];

async function signIn(page: Page, identifier: string, password: string) {
  await expect(page.getByRole("heading", { name: "Đăng nhập" })).toBeVisible();
  await page.locator('input[name="identifier"]').fill(identifier);
  await page.locator('input[name="password"]').fill(password);
  await page.getByRole("button", { name: "Đăng nhập", exact: true }).click();
}

test("Owner first-login: mật khẩu tạm → đổi → login lại → TOTP → backup code → vào app, reload vẫn giữ phiên", async ({
  page,
  context
}) => {
  const { operatorSlug, owner } = accounts();
  const identifier = `${operatorSlug}/${owner.username}`;
  await page.goto("/");

  await signIn(page, identifier, owner.temporaryPassword);
  await expect(page.getByRole("heading", { name: "Đổi mật khẩu tạm" })).toBeVisible();
  // Chưa có phiên nào trước khi hoàn tất đổi mật khẩu + MFA.
  expect((await context.cookies(API)).some((cookie) => cookie.name === "vxn_access")).toBe(false);
  await page.locator('input[name="newPassword"]').fill(owner.newPassword);
  await page.locator('input[name="confirmPassword"]').fill(owner.newPassword);
  await page.getByRole("button", { name: "Đổi mật khẩu" }).click();

  // Thành công hiện hộp thoại; đóng hộp thoại mới quay về màn đăng nhập (không tự vào app).
  const changed = page.getByRole("alertdialog", { name: "Đổi mật khẩu thành công" });
  await expect(changed).toBeVisible();
  await changed.getByRole("button", { name: "Quay lại đăng nhập" }).click();
  await signIn(page, identifier, owner.newPassword);

  await expect(page.getByRole("heading", { name: "Bật xác thực hai lớp" })).toBeVisible();
  await expect(page.getByAltText("Mã QR thiết lập xác thực hai lớp")).toBeVisible();
  // Khóa thiết lập hiển thị theo nhóm 4 ký tự.
  const secret = (await page.locator("code").innerText()).replace(/\s+/g, "");
  await page.locator('input[name="code"]').fill(totp(secret));
  await page.getByRole("button", { name: "Xác nhận" }).click();

  await expect(page.getByRole("heading", { name: "Mã dự phòng" })).toBeVisible();
  backupCodes = await page.getByRole("listitem").allInnerTexts();
  expect(backupCodes).toHaveLength(10);
  await page.getByRole("button", { name: "Tôi đã lưu mã, vào trang quản lý" }).click();

  await expect(page.getByRole("navigation", { name: "Điều hướng chính" })).toBeVisible();

  const cookies = await context.cookies(API);
  expect(cookies.find((cookie) => cookie.name === "vxn_access")).toMatchObject({
    httpOnly: true,
    sameSite: "Lax",
    path: "/v1"
  });
  expect(cookies.find((cookie) => cookie.name === "vxn_refresh")).toBeUndefined(); // Path /v1/auth/refresh
  expect(
    (await context.cookies(`${API}/auth/refresh`)).find((cookie) => cookie.name === "vxn_refresh")
  ).toMatchObject({ httpOnly: true, sameSite: "Strict" });

  // Backup code không còn trên trang sau khi rời màn.
  await page.reload();
  await expect(page.getByRole("navigation", { name: "Điều hướng chính" })).toBeVisible();
  await expect(page.getByText(backupCodes[0]!)).toHaveCount(0);
});

test("access cookie hết hạn → đúng MỘT lần refresh rồi vào lại app", async ({ page, context }) => {
  const { operatorSlug, owner } = accounts();
  await page.goto("/");
  await signIn(page, `${operatorSlug}/${owner.username}`, owner.newPassword);
  await page.locator('input[name="code"]').fill(backupCodes.shift()!);
  await page.getByRole("button", { name: "Xác nhận" }).click();
  await expect(page.getByRole("navigation", { name: "Điều hướng chính" })).toBeVisible();

  await context.clearCookies({ name: "vxn_access" });
  const refreshes: string[] = [];
  page.on("request", (request) => {
    if (request.url().endsWith("/auth/refresh")) {
      refreshes.push(request.url());
    }
  });
  await page.reload();
  await expect(page.getByRole("navigation", { name: "Điều hướng chính" })).toBeVisible();
  expect(refreshes).toHaveLength(1);
});

test("nhân viên đăng nhập Operator OS → lỗi chung từ cổng Owner, không có phiên (TASK-IAM-006)", async ({
  page,
  context
}) => {
  const { operatorSlug, employee } = accounts();
  await page.goto("/");
  await signIn(page, `${operatorSlug}/${employee.username}`, employee.password);

  // Cổng `/auth/operator/login` không tra bảng nhân viên → cùng lỗi như sai mật khẩu, không lộ tài khoản.
  await expect(page.getByText("Tên đăng nhập hoặc mật khẩu không đúng")).toBeVisible();
  await expect(page.getByRole("heading", { name: "Đăng nhập" })).toBeVisible();
  await expect(page.getByRole("navigation", { name: "Điều hướng chính" })).toHaveCount(0);
  expect((await context.cookies(API)).some((cookie) => cookie.name === "vxn_access")).toBe(false);
});

test("màn đăng nhập: cấp lại mật khẩu chỉ hướng dẫn liên hệ; chưa có lối đăng ký nhà xe", async ({ page, context }) => {
  // Phiên của ca trước còn trong cookie → xoá để về màn đăng nhập.
  await context.clearCookies();
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "Đăng nhập nhà xe" })).toBeVisible();

  // Owner không tự đặt lại mật khẩu (closed enrollment): link chỉ mở hướng dẫn, không gọi API.
  await page.getByRole("button", { name: "Cần cấp lại mật khẩu?" }).click();
  const help = page.getByRole("alertdialog", { name: "Cấp lại mật khẩu" });
  await expect(help.getByText("liên hệ quản trị nền tảng")).toBeVisible();
  await help.getByRole("button", { name: "Đã hiểu" }).click();
  await expect(help).toHaveCount(0);

  // Khối "Trở thành đối tác" ẩn tới khi có form đăng ký (TASK-OPR-001).
  await expect(page.getByText("Trở thành đối tác")).toHaveCount(0);

  // Nút hiện/ẩn mật khẩu đổi kiểu ô nhập.
  const password = page.locator('input[name="password"]');
  await password.fill("mat-khau-thu");
  await expect(password).toHaveAttribute("type", "password");
  await page.getByRole("button", { name: "Hiện mật khẩu" }).click();
  await expect(password).toHaveAttribute("type", "text");
});
