import { execSync } from "node:child_process";
import { createHmac } from "node:crypto";
import { resolve } from "node:path";

import { expect, type Page } from "@playwright/test";

/** Phần tài khoản của seed E2E mà cổng Admin dùng. */
export type E2eAccounts = {
  operatorSlug: string;
  fleetOwner: { username: string; password: string };
  /** Tài xế của nhà xe E2E (màn Người dùng → Nhân viên nhà xe). */
  employee: { username: string; password: string };
  platform: { username: string; password: string };
  /** Quản trị viên riêng cho E2E duyệt hồ sơ nhà xe. */
  platformReviewer: { username: string; password: string };
  /** Quản trị viên riêng cho E2E màn Điểm dừng. */
  platformCatalog: { username: string; password: string };
  /** Quản trị viên riêng cho E2E màn Danh mục chuẩn. */
  platformData: { username: string; password: string };
  platformModeration: { username: string; password: string };
  platformContent: { username: string; password: string };
  platformUsers: { username: string; password: string };
  adminUsers: { operatorName: string; operatorSlug: string; passengerEmail: string };
  /** Quản trị viên riêng cho E2E màn Chính sách + nhà xe làm phạm vi riêng / mức hoa hồng riêng. */
  platformPolicy: { username: string; password: string };
  adminPolicy: { operatorName: string; operatorSlug: string };
  /** Quản trị viên riêng cho E2E màn Chi trả nhà xe + kỳ chờ rà soát của nhà xe đặt vé. */
  platformFinance: { username: string; password: string };
  /** Quản trị viên riêng cho E2E màn Thanh toán & hoàn tiền (TASK-ADM-002). */
  platformPayments: { username: string; password: string };
  bookingFixtures: {
    operatorName: string;
    payoutCode: string;
    confirmedCode: string;
    /** Thanh toán trùng cần đối soát, chưa xử lý. */
    reconcilePaymentCode: string;
    /** Hoàn tiền thất bại chờ Admin xử lý. */
    failedRefundCode: string;
  } | null;
  /** Nhà xe riêng có một xe hai ảnh; `null` khi chưa có loại xe. */
  moderation: { operatorName: string; plateNumber: string; captions: string[] } | null;
  /** `null` khi catalog chưa seed. */
  adminStopPoints: {
    proposalName: string;
    rejectProposalName: string;
    privatePointName: string;
    operatorName: string;
    provinceName: string;
    wardName: string;
  } | null;
};

type Credentials = { username: string; password: string };

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
 * Đăng nhập tài khoản Platform chưa bật TOTP rồi hoàn tất enrollment (bắt buộc với quản trị viên) để vào cổng.
 * Trả về khóa TOTP để spec đăng nhập lại tự sinh mã.
 */
export async function signInPlatform(page: Page, platform: Credentials = accounts().platform): Promise<string> {
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "Đăng nhập quản trị" })).toBeVisible();
  await page.locator('input[name="identifier"]').fill(`platform/${platform.username}`);
  await page.locator('input[name="password"]').fill(platform.password);
  await page.getByRole("button", { name: "Đăng nhập", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Bật xác thực hai lớp" })).toBeVisible();
  const secret = (await page.locator("code").innerText()).replace(/\s+/g, "");
  await page.locator('input[name="code"]').fill(totp(secret));
  await page.getByRole("button", { name: "Xác nhận" }).click();
  await page.getByRole("button", { name: "Tôi đã lưu mã, vào cổng quản trị" }).click();
  await expect(page.getByRole("navigation", { name: "Điều hướng chính" })).toBeVisible();
  return secret;
}

export const API = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:3000/v1";
const PDF = Buffer.from("%PDF-1.7\n% E2E\n");

/** Giả lập mở email: cấp link bảo mật mới cho hồ sơ mới nhất của email (script của API, ghi thẳng DB test). */
function issueApplicationLink(email: string): string {
  const output = execSync(`pnpm --filter @vexenhanh/api exec tsx prisma/e2e-application-link.ts ${email}`, {
    cwd: resolve(__dirname, "../../.."),
    encoding: "utf8",
    stdio: ["ignore", "pipe", "inherit"]
  });
  return output.trim().split(/\r?\n/).at(-1) ?? "";
}

async function call(path: string, init: { method: string; token?: string; body?: unknown }): Promise<unknown> {
  const response = await fetch(`${API}${path}`, {
    method: init.method,
    headers: {
      ...(init.token ? { "X-Application-Token": init.token } : {}),
      ...(init.body === undefined ? {} : { "Content-Type": "application/json" })
    },
    body: init.body === undefined ? undefined : JSON.stringify(init.body)
  });
  if (!response.ok) {
    throw new Error(`${init.method} ${path} → ${response.status} ${await response.text()}`);
  }
  return response.status === 202 || response.status === 204 ? null : response.json();
}

/** Bộ thông tin hồ sơ đủ để gửi duyệt; `taxCode` truyền vào để tạo hồ sơ trùng mã số thuế. */
export type SubmittedApplication = { code: string; email: string; operatorName: string; taxCode: string };

/**
 * Người nộp đi hết luồng đăng ký qua API công khai (TASK-OPR-001): tạo hồ sơ → mở link → tải ba giấy tờ lên kho
 * dev → lưu thông tin → gửi duyệt. Trả mã hồ sơ để màn Admin tìm.
 */
export async function submitApplication(name: string, taxCode: string): Promise<SubmittedApplication> {
  const email = `${name}@e2e.example`;
  const operatorName = `Nhà xe ${name}`;
  await call("/operator-applications", {
    method: "POST",
    body: { operatorName, contactName: "Nguyễn Văn E2E", contactEmail: email, acceptTerms: true }
  });
  return resubmitApplication({ email, operatorName, taxCode });
}

/** Mở link mới (như người nộp mở email), lưu đủ thông tin + giấy tờ rồi gửi duyệt — dùng cả khi gửi lại sau bổ sung. */
export async function resubmitApplication(input: {
  email: string;
  operatorName: string;
  taxCode: string;
}): Promise<SubmittedApplication> {
  const token = issueApplicationLink(input.email);
  const current = (await call("/operator-applications/current", { method: "GET", token })) as {
    applicationCode: string;
  };
  const documents = [];
  for (const type of ["BUSINESS_REGISTRATION", "TRANSPORT_LICENSE", "REPRESENTATIVE_AUTHORIZATION"]) {
    const upload = (await call("/operator-applications/current/documents", {
      method: "POST",
      token,
      body: { type, contentType: "application/pdf", sizeBytes: PDF.length, fileName: `${type.toLowerCase()}.pdf` }
    })) as { uploadUrl: string; objectKey: string };
    const put = await fetch(upload.uploadUrl, { method: "PUT", headers: { "Content-Type": "application/pdf" }, body: PDF });
    expect(put.ok).toBe(true);
    documents.push({ type, objectKey: upload.objectKey, fileName: `${type.toLowerCase()}.pdf` });
  }
  await call("/operator-applications/current", {
    method: "PUT",
    token,
    body: {
      legalName: `Công ty TNHH ${input.operatorName}`,
      taxCode: input.taxCode,
      hotline: "19006868",
      address: "266 Đồng Đen, TP. Hồ Chí Minh",
      displayName: input.operatorName,
      description: null,
      bankName: "Vietcombank",
      bankAccountNumber: `9${input.taxCode}`,
      bankAccountHolder: "CTY TNHH E2E",
      documents
    }
  });
  await call("/operator-applications/current/submit", { method: "POST", token });
  return { code: current.applicationCode, ...input };
}
