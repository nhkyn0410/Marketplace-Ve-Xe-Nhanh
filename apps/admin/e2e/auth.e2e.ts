import { expect, test, type Page } from "@playwright/test";

import { accounts, signInPlatform, totp } from "./helpers";

// TASK-IAM-006 phần web Admin (Figma ADM-00a / 00b): đăng nhập `platform/{username}` → bật TOTP bắt buộc → mã dự
// phòng → khung Admin; tài khoản nhà xe không vào được cổng này; đăng xuất rồi đăng nhập lại chỉ cần mã TOTP.
test.describe.configure({ mode: "serial" });

const API = "http://localhost:3000/v1";
let page: Page;
let secret = "";

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
});

test.afterAll(async () => {
  await page.close();
});

test("màn đăng nhập quản trị: không có đăng ký công khai; tài khoản nhà xe bị từ chối bằng lỗi chung", async () => {
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "Đăng nhập quản trị" })).toBeVisible();
  await expect(page.getByText("Không có đăng ký công khai.", { exact: false })).toBeVisible();
  await expect(page.getByText("Trở thành đối tác")).toHaveCount(0);

  // Tài khoản Owner của nhà xe dùng ở cổng Admin: cùng một lỗi chung như sai mật khẩu.
  const { operatorSlug, fleetOwner } = accounts();
  await page.locator('input[name="identifier"]').fill(`${operatorSlug}/${fleetOwner.username}`);
  await page.locator('input[name="password"]').fill(fleetOwner.password);
  await page.getByRole("button", { name: "Đăng nhập", exact: true }).click();
  await expect(page.getByText("Tên đăng nhập hoặc mật khẩu không đúng")).toBeVisible();
  expect((await page.context().cookies(API)).some((cookie) => cookie.name === "vxn_access")).toBe(false);
});

test("quản trị viên lần đầu: bật xác thực hai lớp (bắt buộc), lưu mã dự phòng, vào khung Admin", async () => {
  secret = await signInPlatform(page);
  await expect(page.getByRole("heading", { name: "Tổng quan nền tảng" })).toBeVisible();
  const { platform } = accounts();
  await expect(page.getByText(`platform/${platform.username}`)).toBeVisible();
  await expect(page.getByText("Quản trị viên nền tảng")).toBeVisible();
  await expect(page.getByText("Platform · Nội bộ")).toBeVisible();

  // Mục chưa làm có trang giữ chỗ.
  await page.getByRole("link", { name: "Chi trả nhà xe" }).click();
  await expect(page.getByText("Chưa có trong phiên bản này")).toBeVisible();

  // Tải lại trang vẫn giữ phiên.
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "Tổng quan nền tảng" })).toBeVisible();
});

test("đăng xuất → về màn đăng nhập; đăng nhập lại chỉ cần mã TOTP", async () => {
  await page.getByRole("button", { name: "Đăng xuất" }).click();
  await expect(page.getByRole("heading", { name: "Đăng nhập quản trị" })).toBeVisible();
  expect((await page.context().cookies(API)).some((cookie) => cookie.name === "vxn_access")).toBe(false);

  const { platform } = accounts();
  await page.locator('input[name="identifier"]').fill(`platform/${platform.username}`);
  await page.locator('input[name="password"]').fill(platform.password);
  await page.getByRole("button", { name: "Đăng nhập", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Xác thực hai lớp" })).toBeVisible();
  await expect(page.getByText("Tiếp tục quản trị.")).toBeVisible();
  // Mã của khung 30 giây kế tiếp: tránh trùng mã vừa dùng lúc bật TOTP (API chặn dùng lại mã).
  await page.locator('input[name="code"]').fill(totp(secret, Date.now() + 30_000));
  await page.getByRole("button", { name: "Xác nhận" }).click();
  await expect(page.getByRole("heading", { name: "Tổng quan nền tảng" })).toBeVisible();
});
