import { createHmac } from "node:crypto";

import { expect, type Page } from "@playwright/test";

export type E2eAccounts = {
  operatorSlug: string;
  owner: { username: string; temporaryPassword: string; newPassword: string };
  /** Owner riêng cho E2E màn nghiệp vụ: mật khẩu thường, chưa bật TOTP. */
  fleetOwner: { username: string; password: string };
  /** Owner riêng cho E2E màn điểm dừng / tuyến đường: mật khẩu thường, chưa bật TOTP. */
  routeOwner: { username: string; password: string };
  employee: { username: string; password: string };
  platform: { username: string; password: string };
};

/** Tài khoản do global-setup seed cho lần chạy này. */
export function accounts(): E2eAccounts {
  const raw = process.env.E2E_WEB_AUTH_ACCOUNTS;
  if (!raw) {
    throw new Error("Thiếu E2E_WEB_AUTH_ACCOUNTS — global-setup chưa chạy.");
  }
  return JSON.parse(raw) as E2eAccounts;
}

/** TOTP RFC 6238 (SHA-1, 30 s, 6 số) — giống app authenticator, để E2E hoàn tất enrollment. */
export function totp(secretBase32: string, nowMs = Date.now()): string {
  const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
  let bits = "";
  for (const char of secretBase32.replace(/=+$/, "").toUpperCase()) {
    bits += alphabet.indexOf(char).toString(2).padStart(5, "0");
  }
  const key = Buffer.from((bits.match(/.{8}/g) ?? []).map((byte) => parseInt(byte, 2)));
  const counter = Buffer.alloc(8);
  counter.writeBigUInt64BE(BigInt(Math.floor(nowMs / 1000 / 30)));
  const hmac = createHmac("sha1", key).update(counter).digest();
  const offset = hmac[hmac.length - 1]! & 0x0f;
  const code = (hmac.readUInt32BE(offset) & 0x7fffffff) % 1_000_000;
  return code.toString().padStart(6, "0");
}

/**
 * Thay bản đồ nền Goong bằng một nền trống để E2E không gọi ra ngoài và không cần khóa thật (TASK-TRN-014).
 * Ghim, đường nối và thao tác trên bản đồ vẫn kiểm được; hình bản đồ thật thì không — phần đó kiểm tay.
 */
export async function stubMapTiles(page: Page): Promise<void> {
  await page.route("https://tiles.goong.io/**", (route) =>
    route.fulfill({ contentType: "application/json", body: JSON.stringify({ version: 8, sources: {}, layers: [] }) })
  );
}

/**
 * Đăng nhập Owner chưa bật TOTP rồi hoàn tất enrollment (QR + mã + lưu backup code) để vào app.
 * Dùng cho các spec màn nghiệp vụ; luồng đăng nhập đầy đủ được kiểm ở `auth.e2e.ts`.
 */
export async function signInWithEnrollment(page: Page, identifier: string, password: string): Promise<void> {
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "Đăng nhập" })).toBeVisible();
  await page.locator('input[name="identifier"]').fill(identifier);
  await page.locator('input[name="password"]').fill(password);
  await page.getByRole("button", { name: "Đăng nhập", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Bật xác thực hai lớp" })).toBeVisible();
  const secret = (await page.locator("code").innerText()).replace(/\s+/g, "");
  await page.locator('input[name="code"]').fill(totp(secret));
  await page.getByRole("button", { name: "Xác nhận" }).click();
  await page.getByRole("button", { name: "Tôi đã lưu mã, vào trang quản lý" }).click();
  await expect(page.getByRole("navigation", { name: "Điều hướng chính" })).toBeVisible();
}
