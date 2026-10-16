import { randomUUID } from "node:crypto";

import { expect, test, type Locator, type Page } from "@playwright/test";

import { accounts, signInPlatform, totp } from "./helpers";

// Màn Chính sách (Figma ADM-06a…06d; FR-ADM-06..09, UC-25): phiên bản hủy / hoàn tiền (phạm vi riêng của nhà xe seed —
// không đụng chính sách mặc định dùng chung giữa các lần chạy), giữ chỗ / chi trả nền, hoa hồng riêng, khung giá.
test.describe.configure({ mode: "serial" });

const tag = randomUUID().replace(/-/g, "").slice(0, 6);
let page: Page;
let secret = "";

/** Ngày theo giờ Việt Nam sau `days` ngày, dạng ô `date`. */
function vnDate(days: number): string {
  return new Date(Date.now() + 7 * 3_600_000 + days * 86_400_000).toISOString().slice(0, 10);
}

/** Điền mã TOTP nếu ô đang hiện (5 phút sau lần xác nhận trước thì không hỏi lại). */
async function fillTotpIfAsked(scope: Locator) {
  const code = scope.getByLabel("Mã xác thực (TOTP) *");
  if (await code.isVisible()) {
    await code.fill(totp(secret, Date.now() + 30_000));
  }
}

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
  secret = await signInPlatform(page, accounts().platformPolicy);
});

test.afterAll(async () => {
  await page.close();
});

test("hủy và hoàn tiền: phiên bản riêng của nhà xe — lỗi mốc báo tại chỗ, lưu nháp, kích hoạt (lý do + TOTP) → đã lên lịch, hủy lịch", async () => {
  const { operatorName } = accounts().adminPolicy;
  await page.getByRole("link", { name: "Chính sách", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Chính sách", level: 1 })).toBeVisible({ timeout: 20_000 });
  await expect(page.getByRole("region", { name: "Đang áp dụng" })).toBeVisible({ timeout: 20_000 });
  await page.getByRole("link", { name: "Tạo phiên bản mới" }).click();
  await expect(page.getByRole("heading", { name: /Phiên bản mới · Hủy và hoàn tiền/ })).toBeVisible({ timeout: 20_000 });

  await page.getByRole("searchbox", { name: "Tìm nhà xe" }).fill(operatorName);
  await page.getByRole("option", { name: new RegExp(operatorName) }).click();
  await expect(page.getByRole("region", { name: "Tóm tắt ảnh hưởng" })).toContainText(operatorName);

  const refunds = page.getByLabel("Mức hoàn (%)");
  await refunds.last().fill("95");
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Hủy càng sát giờ thì mức hoàn không được cao hơn.")).toBeVisible();
  await refunds.last().fill("0");
  await page.getByRole("button", { name: "Thêm mốc" }).click();
  await refunds.last().fill("50");
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByRole("status")).toContainText("Đã lưu nháp.", { timeout: 20_000 });
  await expect(page.getByRole("heading", { name: /Phiên bản 1 \(nháp\)/ })).toBeVisible();

  await page.getByRole("button", { name: "Kích hoạt phiên bản" }).click();
  await expect(page.getByText("Chọn thời điểm hiệu lực ở tương lai.").first()).toBeVisible();
  await expect(page.getByText("Nhập lý do (ít nhất 3 ký tự).")).toBeVisible();
  await page.getByLabel("Hiệu lực từ *").fill(`${vnDate(30)}T08:00`);
  await expect(page.getByText("Không trùng thời gian hiệu lực với phiên bản khác.")).toBeVisible();
  await page.getByLabel("Lý do thay đổi *").fill("Thỏa thuận riêng với nhà xe");
  await page.getByLabel("Mã xác thực (TOTP) *").fill(totp(secret, Date.now() + 30_000));
  await page.getByRole("button", { name: "Kích hoạt phiên bản" }).click();
  await expect(page.getByRole("status")).toContainText("Đã kích hoạt phiên bản", { timeout: 20_000 });
  await expect(page.getByText("Đã lên lịch").first()).toBeVisible();
  await expect(page.getByRole("region", { name: "Nội dung chính sách" })).toContainText("Hoàn 50%");

  await page.getByRole("button", { name: "Hủy lịch" }).click();
  const dialog = page.getByRole("dialog", { name: "Hủy phiên bản đã lên lịch" });
  await dialog.getByLabel("Lý do *").fill("Đổi kế hoạch hợp tác");
  await fillTotpIfAsked(dialog);
  await dialog.getByRole("button", { name: "Hủy phiên bản" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  await expect(page.getByRole("status").last()).toContainText("Đã hủy phiên bản 1.");
  await expect(page.getByText("Đã hủy").first()).toBeVisible();
});

test("giữ chỗ / chi trả: hiện giá trị nền đang áp dụng (10 phút; T+3, chuyển khoản, xác nhận thủ công)", async () => {
  // Điều hướng trong ứng dụng (không tải lại trang): giữ bằng chứng xác nhận danh tính 5 phút, không phải dùng lại mã TOTP.
  await page.getByRole("link", { name: "Quay lại các phiên bản" }).click();
  await page.getByRole("tab", { name: "Giữ chỗ" }).click();
  const seatHold = page.getByRole("region", { name: "Giữ chỗ" });
  await expect(seatHold).toContainText("10 phút", { timeout: 20_000 });
  await expect(seatHold).toContainText("Toàn nền tảng");
  await page.getByRole("tab", { name: "Chi trả" }).click();
  const payout = page.getByRole("region", { name: "Chi trả cho nhà xe" });
  await expect(payout).toContainText("T+3 sau khi chuyến hoàn thành", { timeout: 20_000 });
  await expect(payout).toContainText("Thủ công bởi Admin");
});

test("hoa hồng: mặc định 5%; thêm mức riêng 4,5% cho nhà xe → đã lên lịch; hủy mức (lý do) → đã hủy", async () => {
  const { operatorName } = accounts().adminPolicy;
  await page.getByRole("tab", { name: "Hoa hồng" }).click();
  await expect(page.getByText("Hoa hồng mặc định", { exact: true })).toBeVisible({ timeout: 20_000 });
  await page.getByRole("button", { name: "Thêm mức riêng cho nhà xe" }).click();
  const dialog = page.getByRole("dialog", { name: "Thêm mức riêng cho nhà xe" });
  await dialog.getByRole("button", { name: "Thêm mức riêng" }).click();
  await expect(dialog.getByText("Chọn nhà xe.")).toBeVisible();
  await dialog.getByRole("searchbox", { name: "Tìm nhà xe" }).fill(operatorName);
  await dialog.getByRole("option", { name: new RegExp(operatorName) }).click();
  await dialog.getByLabel("Tỷ lệ (%) *").fill("4,5");
  await dialog.getByLabel("Hiệu lực từ *").fill(vnDate(5));
  await dialog.getByLabel("Lý do *").fill("Ưu đãi đối tác E2E");
  await fillTotpIfAsked(dialog);
  await dialog.getByRole("button", { name: "Thêm mức riêng" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  const row = page.getByRole("row").filter({ hasText: operatorName });
  await expect(row).toContainText("4,5%");
  await expect(row).toContainText("Đã lên lịch");
  await expect(row).toContainText("Không thời hạn");

  await row.getByRole("button", { name: `Ngừng mức của ${operatorName}` }).click();
  const stop = page.getByRole("dialog", { name: "Hủy mức hoa hồng riêng" });
  await stop.getByLabel("Lý do *").fill("Đối tác rút thỏa thuận");
  await fillTotpIfAsked(stop);
  await stop.getByRole("button", { name: "Hủy mức" }).click();
  await expect(stop).toBeHidden({ timeout: 20_000 });
  await expect(row).toContainText("Đã hủy");
});

test("khung giá vé: thiết lập khung (sàn > trần báo lỗi) → đã lên lịch; hủy khung → đã hủy", async () => {
  const name = `Tết E2E ${tag}`;
  await page.getByRole("tab", { name: "Khung giá vé" }).click();
  await page.getByRole("button", { name: "Thiết lập khung giá" }).click();
  const dialog = page.getByRole("dialog", { name: "Thiết lập khung giá" });
  await dialog.getByLabel("Tên dịp *").fill(name);
  await dialog.getByLabel("Giá sàn (đ)").fill("2.000.000");
  await dialog.getByLabel("Giá trần (đ)").fill("1.000.000");
  await dialog.getByLabel("Từ ngày *").fill(vnDate(300));
  await dialog.getByLabel("Đến hết ngày *").fill(vnDate(310));
  await dialog.getByLabel("Nội dung cảnh báo cho nhà xe *").fill("Giá vượt khung dịp Tết.");
  await dialog.getByLabel("Lý do *").fill("Theo văn bản E2E");
  await dialog.getByRole("button", { name: "Lưu khung giá" }).click();
  await expect(dialog.getByText("Giá trần phải lớn hơn hoặc bằng giá sàn.")).toBeVisible();
  // Trần rất cao để khung giá dùng chung không gây cảnh báo cho các spec khác.
  await dialog.getByLabel("Giá sàn (đ)").fill("");
  await dialog.getByLabel("Giá trần (đ)").fill("99.000.000");
  await fillTotpIfAsked(dialog);
  await dialog.getByRole("button", { name: "Lưu khung giá" }).click();
  await expect(dialog).toBeHidden({ timeout: 20_000 });
  const row = page.getByRole("row").filter({ hasText: name });
  await expect(row).toContainText("99.000.000 đ");
  await expect(row).toContainText("Đã lên lịch");

  await row.getByRole("button", { name: `Hủy khung giá ${name}` }).click();
  const cancel = page.getByRole("dialog", { name: "Hủy khung giá" });
  await cancel.getByLabel("Lý do *").fill("Dọn dữ liệu E2E");
  await fillTotpIfAsked(cancel);
  await cancel.getByRole("button", { name: "Hủy khung giá" }).click();
  await expect(cancel).toBeHidden({ timeout: 20_000 });
  await expect(row).toContainText("Đã hủy");
});

test("tổng quan + tích hợp & hệ thống (chỉ đọc) + màn chờ đặt vé chỉ có khung, không số liệu mẫu", async () => {
  await page.getByRole("link", { name: "Tổng quan", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Tổng quan nền tảng", level: 1 })).toBeVisible({ timeout: 20_000 });
  const queue = page.getByRole("region", { name: "Việc cần xử lý" });
  await expect(queue.getByRole("link", { name: /Hồ sơ nhà xe chờ duyệt/ })).toBeVisible();
  await expect(queue.getByRole("link", { name: /Yêu cầu đổi tài khoản nhận tiền/ })).toBeVisible();
  await expect(queue).toContainText("Chi trả chờ rà soát");

  await page.getByRole("link", { name: "Tích hợp & hệ thống", exact: true }).click();
  await expect(page.getByRole("region", { name: "PostgreSQL" })).toContainText("Hoạt động", { timeout: 20_000 });
  await expect(page.getByRole("region", { name: "VNPay" })).toContainText("Chưa tích hợp");
  await expect(page.getByRole("region", { name: "SMS" })).toContainText("Tắt");
  await page.getByRole("tab", { name: "Tác vụ nền" }).click();
  await expect(page.getByRole("region", { name: "Tác vụ nền" })).toBeVisible({ timeout: 20_000 });

  await page.getByRole("link", { name: "Thanh toán & hoàn tiền", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Thanh toán & hoàn tiền", level: 1 })).toBeVisible({ timeout: 20_000 });
  await expect(page.getByRole("columnheader", { name: "Mã thanh toán" })).toBeVisible();
  await expect(page.getByText("Chưa có dữ liệu", { exact: true })).toBeVisible();
  await page.getByRole("tab", { name: "Hoàn tiền" }).click();
  await expect(page.getByRole("columnheader", { name: "Mã hoàn tiền" })).toBeVisible();
});
