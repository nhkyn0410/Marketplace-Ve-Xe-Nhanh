import { randomUUID } from "node:crypto";

import { expect, test, type Page } from "@playwright/test";

import {
  accounts,
  resubmitApplication,
  signInPlatform,
  submitApplication,
  totp,
  type SubmittedApplication
} from "./helpers";

// TASK-ADM-001 phần duyệt hồ sơ đăng ký nhà xe (Figma ADM-02a…02d, UC-23): hàng đợi + cảnh báo trùng mã số thuế,
// chi tiết + mở giấy tờ, yêu cầu bổ sung → người nộp gửi lại → từ chối (TOTP), duyệt (TOTP) tạo nhà xe + tài khoản
// chủ nhà xe. API chạy không gửi email thật nên mật khẩu tạm / email kết quả báo "chưa gửi được".
test.describe.configure({ mode: "serial" });

const tag = randomUUID().slice(0, 8);
const taxCode = `0${String(Math.floor(1e8 + Math.random() * 8e8))}`;
let page: Page;
let secret = "";
let approved: SubmittedApplication;
let rejected: SubmittedApplication;

test.beforeAll(async ({ browser }) => {
  // Hai hồ sơ cùng mã số thuế → cả hai mang cảnh báo trùng.
  approved = await submitApplication(`e2e-duyet-${tag}`, taxCode);
  rejected = await submitApplication(`e2e-tuchoi-${tag}`, taxCode);
  page = await browser.newPage();
});

test.afterAll(async () => {
  await page.close();
});

/** Mở hồ sơ từ thanh bên như người dùng (điều hướng phía client: bằng chứng xác nhận lại 5 phút còn trong trang). */
async function openApplication(application: SubmittedApplication) {
  await page.getByRole("link", { name: "Nhà xe & KYC" }).click();
  await expect(page.getByRole("heading", { name: "Nhà xe & KYC" })).toBeVisible();
  await page.getByRole("searchbox", { name: "Tìm hồ sơ" }).fill(application.code);
  const row = page.getByRole("row").filter({ hasText: application.code });
  await expect(row).toHaveCount(1);
  await row.getByRole("link", { name: `Xem hồ sơ ${application.code}` }).click();
  // Lần đầu mở route chi tiết, Next dev còn biên dịch trang — chờ lâu hơn mặc định.
  await expect(page.getByRole("heading", { name: `Hồ sơ ${application.code} · ${application.operatorName}` })).toBeVisible({
    timeout: 20_000
  });
}

test("hàng đợi: hồ sơ vừa gửi duyệt ở trạng thái Chờ duyệt, cảnh báo trùng mã số thuế, lọc theo cảnh báo", async () => {
  secret = await signInPlatform(page, accounts().platformReviewer);
  await page.getByRole("link", { name: "Nhà xe & KYC" }).click();
  await expect(page.getByRole("heading", { name: "Nhà xe & KYC" })).toBeVisible();

  await page.getByRole("searchbox", { name: "Tìm hồ sơ" }).fill(tag);
  for (const application of [approved, rejected]) {
    const row = page.getByRole("row").filter({ hasText: application.code });
    await expect(row).toContainText("Chờ duyệt");
    await expect(row).toContainText("Trùng mã số thuế");
    await expect(row).toContainText("Trùng tài khoản nhận tiền");
  }

  await page.getByRole("combobox", { name: "Trạng thái hồ sơ" }).click();
  await page.getByRole("option", { name: "Đã duyệt" }).click();
  await expect(page.getByText("Không có hồ sơ phù hợp")).toBeVisible();
  await page.getByRole("button", { name: "Bỏ lọc" }).click();
  await expect(page.getByRole("row").filter({ hasText: approved.code })).toHaveCount(1);
});

test("chi tiết: thông tin, số tài khoản che, trùng định danh, lịch sử; mở giấy tờ ở tab mới bằng URL có hạn", async () => {
  await openApplication(approved);
  await expect(page.getByText("Gửi duyệt lúc")).toBeVisible();
  await expect(page.getByText(`•••• ${`9${taxCode}`.slice(-4)}`)).toBeVisible();
  await expect(page.getByText(`9${taxCode}`)).toHaveCount(0);
  const duplicates = page.getByRole("region", { name: "Kiểm tra trùng định danh" });
  await expect(duplicates).toContainText(`Mã số thuế: trùng ${rejected.code}`);
  const history = page.getByRole("region", { name: "Lịch sử hồ sơ" });
  await expect(history).toContainText("Gửi duyệt");
  await expect(history).toContainText("Tạo hồ sơ nháp");

  const popup = page.waitForEvent("popup");
  await page.getByRole("button", { name: "Mở tệp Giấy phép kinh doanh vận tải" }).click();
  const tab = await popup;
  await tab.waitForURL(/\/v1\/dev-storage\/download\?token=/);
  await tab.close();
});

test("yêu cầu bổ sung (không cần TOTP) → Cần bổ sung; người nộp gửi lại → từ chối kèm TOTP → Bị từ chối", async () => {
  await openApplication(rejected);
  await page.getByRole("button", { name: "Yêu cầu bổ sung" }).click();
  const ask = page.getByRole("dialog", { name: "Yêu cầu bổ sung hồ sơ" });
  await expect(ask.getByLabel(/Mã xác thực/)).toHaveCount(0);
  await ask.getByRole("button", { name: "Gửi yêu cầu bổ sung" }).click();
  await expect(ask.getByText("Nhập lý do (ít nhất 3 ký tự).")).toBeVisible();
  await ask.getByLabel("Nội dung cần bổ sung *").fill("Bổ sung giấy phép kinh doanh vận tải còn hạn.");
  await ask.getByRole("button", { name: "Gửi yêu cầu bổ sung" }).click();
  await expect(ask).toBeHidden();
  await expect(page.getByText("Đã gửi yêu cầu bổ sung, nhưng chưa gửi được email.", { exact: false })).toBeVisible();
  await expect(page.getByText("Cần bổ sung", { exact: true })).toBeVisible();
  await expect(page.getByRole("button", { name: "Duyệt hồ sơ" })).toHaveCount(0);

  await resubmitApplication(rejected);
  await page.reload();
  await expect(page.getByText("Chờ duyệt", { exact: true })).toBeVisible();
  await expect(page.getByRole("region", { name: "Lịch sử hồ sơ" })).toContainText(
    "“Bổ sung giấy phép kinh doanh vận tải còn hạn.”"
  );

  await page.getByRole("button", { name: "Từ chối", exact: true }).click();
  const reject = page.getByRole("dialog", { name: "Từ chối hồ sơ" });
  await reject.getByLabel("Lý do từ chối *").fill("Giấy tờ không khớp pháp nhân.");
  // Mã của khung 30 giây kế tiếp: tránh trùng mã vừa dùng lúc bật TOTP (API chặn dùng lại mã).
  await reject.getByLabel("Mã xác thực (TOTP) *").fill(totp(secret, Date.now() + 30_000));
  await reject.getByRole("button", { name: "Từ chối hồ sơ" }).click();
  await expect(reject).toBeHidden();
  await expect(page.getByText("Đã từ chối hồ sơ, nhưng chưa gửi được email", { exact: false })).toBeVisible();
  await expect(page.getByText("Lý do từ chối: Giấy tờ không khớp pháp nhân.")).toBeVisible();
  await expect(page.getByText("Bị từ chối", { exact: true })).toBeVisible();
});

test("duyệt: slug đã dùng báo tại ô; slug mới → tạo nhà xe + tài khoản chủ nhà xe, mật khẩu tạm chờ gửi lại", async () => {
  await openApplication(approved);
  await page.getByRole("button", { name: "Duyệt hồ sơ" }).click();
  const dialog = page.getByRole("dialog", { name: "Duyệt hồ sơ và cấp tài khoản chủ nhà xe" });
  // Vừa xác nhận danh tính khi từ chối (bằng chứng 5 phút) → không hỏi lại mã.
  await expect(dialog.getByLabel("Mã xác thực (TOTP) *")).toHaveCount(0);

  await dialog.getByLabel("Mã nhà xe (slug) *").fill(accounts().operatorSlug);
  await dialog.getByLabel("Tên đăng nhập chủ nhà xe *").fill("nv.owner");
  await dialog.getByRole("button", { name: "Duyệt và cấp tài khoản" }).click();
  await expect(dialog.getByText("Tên đăng nhập chủ nhà xe không bắt đầu bằng", { exact: false })).toBeVisible();
  await dialog.getByLabel("Tên đăng nhập chủ nhà xe *").fill("owner01");
  await dialog.getByRole("button", { name: "Duyệt và cấp tài khoản" }).click();
  await expect(dialog.getByText("Mã nhà xe đã được dùng. Hãy chọn mã khác.")).toBeVisible();

  const slug = `e2e-duyet-${tag}`;
  await dialog.getByLabel("Mã nhà xe (slug) *").fill(slug);
  await dialog.getByRole("button", { name: "Duyệt và cấp tài khoản" }).click();
  await expect(dialog).toBeHidden();
  await expect(page.getByText(`Đã duyệt và tạo tài khoản ${slug}/owner01, nhưng chưa gửi được mật khẩu tạm.`)).toBeVisible();
  await expect(page.getByText("Đã duyệt", { exact: true })).toBeVisible();
  await expect(page.getByRole("button", { name: "Gửi lại mật khẩu tạm" })).toBeVisible();
  await expect(page.getByRole("region", { name: "Lịch sử hồ sơ" })).toContainText("Duyệt hồ sơ");

  // Gửi lại vẫn lỗi vì môi trường E2E không gửi email thật → báo lỗi trong hộp thoại, hồ sơ giữ nguyên.
  await page.getByRole("button", { name: "Gửi lại mật khẩu tạm" }).click();
  const resend = page.getByRole("dialog", { name: "Gửi lại mật khẩu tạm" });
  await resend.getByRole("button", { name: "Gửi lại mật khẩu tạm" }).click();
  await expect(resend.getByRole("alert")).toBeVisible();
  await resend.getByRole("button", { name: "Hủy" }).click();

  await page.getByRole("link", { name: "Quay lại hàng đợi hồ sơ" }).click();
  await page.getByRole("searchbox", { name: "Tìm hồ sơ" }).fill(tag);
  await expect(page.getByRole("row").filter({ hasText: approved.code })).toContainText("Đã duyệt");
  await expect(page.getByRole("row").filter({ hasText: rejected.code })).toContainText("Bị từ chối");
});
