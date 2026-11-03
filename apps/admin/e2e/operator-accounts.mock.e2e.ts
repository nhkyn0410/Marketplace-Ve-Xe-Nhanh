import { expect, test, type Page } from "@playwright/test";

const operatorId = "00000000-0000-4000-8000-000000000101";
const ownerId = "00000000-0000-4000-8000-000000000102";
const managerId = "00000000-0000-4000-8000-000000000103";
const owner = {
  id: ownerId, username: "sao-viet/owner01", email: "owner@example.test", operatorId, operatorName: "Nhà xe Sao Việt", operatorStatus: "ACTIVE",
  role: "OPERATOR_OWNER", status: "ACTIVE", mfaEnabled: true, passwordChangeRequired: false, credentialDeliveryPending: false,
  temporaryPasswordExpiresAt: null, createdAt: "2026-10-01T01:00:00.000Z", lastLoginAt: "2026-11-01T01:00:00.000Z"
};

async function mockApi(page: Page, permissions = ["user:manage", "access:manage"], pending = false) {
  const resets: { id: string; reason: string }[] = [];
  const queries: URLSearchParams[] = [];
  await page.route("**/v1/**", async (route) => {
    const request = route.request();
    const url = new URL(request.url());
    const headers = { "access-control-allow-origin": "http://localhost:3003", "access-control-allow-credentials": "true", "access-control-allow-headers": "content-type,x-csrf-token" };
    const fulfill = (json: unknown) => route.fulfill({ status: 200, headers, json });
    if (request.method() === "OPTIONS") {
      await route.fulfill({ status: 204, headers });
    } else if (url.pathname === "/v1/auth/csrf") {
      await fulfill({ csrfToken: "mock-csrf" });
    } else if (url.pathname === "/v1/auth/me") {
      await fulfill({ subjectId: "admin", scope: "platform", role: "PLATFORM_ADMIN", username: "admin", sessionId: "session", accessExpiresAt: "2099-01-01T00:00:00.000Z", mfaVerified: true, permissions });
    } else if (url.pathname === "/v1/admin/operator-accounts") {
      queries.push(url.searchParams);
      await fulfill({ items: [owner, { ...owner, id: managerId, username: "sao-viet/manager01", role: "OPERATOR_MANAGER", status: "LOCKED" }], total: 2, nextCursor: null, operators: [{ id: operatorId, name: "Nhà xe Sao Việt" }] });
    } else if (url.pathname.endsWith("/reset-password")) {
      resets.push({ id: url.pathname.split("/").at(-2)!, ...request.postDataJSON() });
      await fulfill({ ...owner, passwordChangeRequired: true, credentialDeliveryPending: pending });
    } else if (url.pathname === "/v1/admin/operators") {
      await fulfill({ items: [{ id: operatorId, name: "Nhà xe Sao Việt", slug: "sao-viet", status: "ACTIVE", suspendedReason: null, suspendedAt: null, approvedAt: owner.createdAt, applicationId: null, owner: { id: ownerId, username: owner.username, email: owner.email, status: "ACTIVE", credentialDeliveryPending: true }, routeCount: 2, openTripCount: 3, bankChangePending: false }], nextCursor: null, total: 1 });
    } else if (url.pathname === `/v1/admin/operators/${operatorId}`) {
      await fulfill({ id: operatorId, name: "Nhà xe Sao Việt", slug: "sao-viet", status: "ACTIVE", suspendedReason: null, suspendedAt: null, approvedAt: owner.createdAt, applicationId: null, owner: { id: ownerId, username: owner.username, email: owner.email, status: "ACTIVE", credentialDeliveryPending: false }, routeCount: 2, openTripCount: 3, bankChangePending: false, legalName: null, taxCode: null, hotline: null, publicEmail: null, address: null, description: null, bankAccount: null, vehicleCount: 0, employeeCount: 0, stats: { from: "2026-10-01", to: "2026-10-31", trips: 3, completedTrips: 2, cancelledTrips: 0, seats: 30, ticketsSold: 20, ticketRevenue: null, refunded: null, averageRating: null, reviewCount: 0 } });
    } else {
      await fulfill({ items: [], total: 0, nextCursor: null });
    }
  });
  return { resets, queries };
}

test("Người dùng: có Owner / Manager, tìm kiếm, khóa nút tài khoản bị khóa và xác nhận cấp lại bằng lý do + TOTP", async ({ page }, testInfo) => {
  const { resets, queries } = await mockApi(page);
  await page.goto("/users?tab=operators");
  await expect(page.getByRole("tab", { name: "Tài khoản nhà xe", exact: true })).toHaveAttribute("data-state", "active");
  await expect(page.getByRole("row").filter({ hasText: "sao-viet/owner01" })).toContainText("Chủ nhà xe");
  await expect(page.getByRole("button", { name: "Cấp lại mật khẩu cho sao-viet/manager01", exact: true })).toBeDisabled();
  await page.screenshot({ path: testInfo.outputPath("operator-accounts.png"), fullPage: true });
  await page.getByRole("searchbox", { name: "Tìm tài khoản nhà xe" }).fill("sao-viet/owner01");
  await expect.poll(() => queries.some((query) => query.get("q") === "sao-viet/owner01")).toBe(true);
  await page.getByRole("button", { name: "Cấp lại mật khẩu cho sao-viet/owner01", exact: true }).click();
  const dialog = page.getByRole("dialog", { name: "Cấp lại mật khẩu tạm" });
  await dialog.getByRole("button", { name: "Cấp lại mật khẩu", exact: true }).click();
  await expect(dialog.getByText("Nhập lý do (ít nhất 3 ký tự).")).toBeVisible();
  expect(resets).toHaveLength(0);
  await dialog.getByLabel("Lý do *").fill("Nhà xe quên mật khẩu");
  await dialog.getByLabel("Mã xác thực (TOTP) *").fill("123456");
  await dialog.getByRole("button", { name: "Cấp lại mật khẩu", exact: true }).click();
  await expect(dialog).toBeHidden();
  await expect(page.getByRole("status")).toContainText("Đã gửi mật khẩu tạm");
  expect(resets).toEqual([{ id: ownerId, reason: "Nhà xe quên mật khẩu" }]);
});

test("Nhà xe: gửi lại mật khẩu hoạt động độc lập hồ sơ KYC, email lỗi hiện cảnh báo và có lối xem tài khoản", async ({ page }) => {
  const { resets, queries } = await mockApi(page, ["user:manage"], true);
  await page.goto("/operators?tab=operators");
  const row = page.getByRole("row").filter({ hasText: "sao-viet/owner01" });
  await expect(row.getByRole("button", { name: "Tạm khóa nhà xe Nhà xe Sao Việt" })).toBeVisible();
  await row.getByRole("button", { name: "Cấp lại mật khẩu cho sao-viet/owner01" }).click();
  const dialog = page.getByRole("dialog", { name: "Cấp lại mật khẩu tạm" });
  await dialog.getByLabel("Lý do *").fill("Gửi lại mật khẩu tạm");
  await dialog.getByLabel("Mã xác thực (TOTP) *").fill("123456");
  await dialog.getByRole("button", { name: "Cấp lại mật khẩu", exact: true }).click();
  await expect(dialog).toBeHidden();
  await expect(page.getByRole("status")).toContainText("chưa gửi được email");
  expect(resets).toHaveLength(1);
  await row.getByRole("link", { name: "Xem tài khoản nhà xe Nhà xe Sao Việt" }).click();
  await expect(page.getByRole("tab", { name: "Tài khoản nhà xe", exact: true })).toHaveAttribute("data-state", "active");
  await expect.poll(() => queries.some((query) => query.get("operatorId") === operatorId)).toBe(true);
  await expect(page.getByRole("button", { name: "Cấp lại mật khẩu chủ nhà xe", exact: true })).toBeVisible();
});

test("chỉ có access:manage: không hiện tab tài khoản nhà xe và không gọi API danh sách nhà xe", async ({ page }) => {
  const { queries } = await mockApi(page, ["access:manage"]);
  await page.goto("/users?tab=operators");
  await expect(page.getByRole("tab", { name: "Tài khoản quản trị", exact: true })).toHaveAttribute("data-state", "active");
  await expect(page.getByRole("tab", { name: "Tài khoản nhà xe", exact: true })).toHaveCount(0);
  expect(queries).toHaveLength(0);
});
