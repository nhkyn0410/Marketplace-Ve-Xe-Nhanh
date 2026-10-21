import { randomUUID } from "node:crypto";

import { expect, test, type Page } from "@playwright/test";

import { issueApplicationLink } from "./helpers";

// TASK-OPR-001 — đăng ký nhà xe công khai (UC-10, BR-75, Figma "Đăng ký nhà xe" 01–06): đăng ký → mở link bảo mật
// (cấp thẳng trong DB test vì E2E không gửi email) → hoàn thiện hồ sơ + giấy tờ → gửi duyệt → link cũ / sai không còn
// dùng được → gửi lại link. Không cần đăng nhập. Giấy tờ đi qua kho ổ đĩa local của API.
test.describe.configure({ mode: "serial" });

const PDF = Buffer.from("%PDF-1.7\n1 0 obj << /Type /Catalog >> endobj\ntrailer << >>\n%%EOF\n");
const email = `nhaxe-${randomUUID().slice(0, 8)}@example.com`;
let page: Page;
let token = "";
let applicationCode = "";

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
});

test.afterAll(async () => {
  await page.close();
});

const pdf = (name: string) => ({ name, mimeType: "application/pdf", buffer: PDF });

test("màn đăng nhập → Đăng ký → gửi đăng ký → nhắc kiểm tra hộp thư (không lộ email đã có hồ sơ hay chưa)", async () => {
  await page.goto("/");
  await expect(page.getByText("Trở thành đối tác")).toBeVisible();
  await page.getByRole("link", { name: "Đăng ký", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Đăng ký trở thành đối tác nhà xe" })).toBeVisible();
  // Trang công khai: không có khung quản trị.
  await expect(page.getByRole("link", { name: "Phương tiện", exact: true })).toHaveCount(0);

  await page.getByRole("button", { name: "Gửi đăng ký" }).click();
  await expect(page.getByText("Nhập tên nhà xe.")).toBeVisible();
  await expect(page.getByText("Cần đồng ý điều khoản để gửi đăng ký.")).toBeVisible();

  await page.getByLabel("Tên nhà xe *").fill("Sao Việt Express E2E");
  await page.getByLabel("Họ tên người liên hệ *").fill("Nguyễn Thanh Sao");
  await page.getByLabel("Email liên hệ *").fill(email);
  await page.getByLabel("Tôi đồng ý Điều khoản đối tác và Chính sách bảo mật của Vé Xe Nhanh.").check();
  await page.getByRole("button", { name: "Gửi đăng ký" }).click();

  await expect(page.getByRole("heading", { name: "Kiểm tra hộp thư của bạn" })).toBeVisible();
  await expect(page.getByText(email)).toBeVisible();
});

test("mở link: token rời thanh địa chỉ; thiếu giấy tờ thì chưa gửi duyệt được; lưu nháp kèm 3 giấy tờ", async () => {
  token = issueApplicationLink(email);
  await page.goto(`/register/application#token=${token}`);
  const heading = page.getByRole("heading", { name: /^Hồ sơ đăng ký OA-\d{4}-\d{6}$/ });
  await expect(heading).toBeVisible();
  applicationCode = ((await heading.textContent()) ?? "").replace("Hồ sơ đăng ký ", "").trim();
  await expect(page).toHaveURL(/\/register\/application$/);
  await expect(page.getByText(`Email liên hệ đã được xác minh: ${email}`)).toBeVisible();
  await expect(page.getByLabel("Tên hiển thị *")).toHaveValue("Sao Việt Express E2E");
  await expect(page.getByRole("button", { name: "Gửi duyệt" })).toBeDisabled();
  await expect(page.getByText("Giấy tờ KYC · thiếu 3 giấy tờ")).toBeVisible();

  // Định dạng sai báo ngay dưới ô.
  await page.getByLabel("Mã số thuế *").fill("123");
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Mã số thuế gồm 10 hoặc 13 chữ số.")).toBeVisible();

  await page.getByLabel("Tên pháp nhân *").fill("Công ty TNHH Sao Việt E2E");
  await page.getByLabel("Mã số thuế *").fill("0312 345 678");
  await page.getByLabel("Hotline *").fill("1900 6868");
  await page.getByLabel("Địa chỉ trụ sở *").fill("266 Đồng Đen, TP. Hồ Chí Minh");
  await page.getByLabel("Ngân hàng *").click();
  await page.getByRole("option", { name: "Vietcombank", exact: true }).click();
  await page.getByLabel("Số tài khoản *").fill("0071 0045 21");
  await page.getByLabel("Tên chủ tài khoản *").fill("CTY TNHH SAO VIET");

  // Tệp sai loại bị từ chối tại chỗ.
  await page
    .getByLabel("Chọn tệp Giấy chứng nhận đăng ký doanh nghiệp")
    .setInputFiles({ name: "anh.gif", mimeType: "image/gif", buffer: Buffer.from("GIF89a") });
  await expect(page.getByText("Định dạng không được hỗ trợ. Chọn PDF, JPEG hoặc PNG.")).toBeVisible();

  await page.getByLabel("Chọn tệp Giấy chứng nhận đăng ký doanh nghiệp").setInputFiles(pdf("dkkd.pdf"));
  await expect(page.getByText("dkkd.pdf · chưa lưu")).toBeVisible();
  await page.getByLabel("Chọn tệp Giấy phép kinh doanh vận tải").setInputFiles(pdf("gpkd.pdf"));
  await expect(page.getByText("gpkd.pdf · chưa lưu")).toBeVisible();
  await page.getByLabel("Chọn tệp Giấy tờ người đại diện hoặc giấy ủy quyền").setInputFiles(pdf("cccd.pdf"));
  await expect(page.getByText("cccd.pdf · chưa lưu")).toBeVisible();
  await expect(page.getByRole("button", { name: "Gửi duyệt" })).toBeEnabled();

  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Đã lưu nháp hồ sơ.")).toBeVisible();
  await expect(page.getByText(/^dkkd\.pdf · tải lên \d{2}\/\d{2} · \d{2}:\d{2}$/)).toBeVisible();
  // Số tài khoản không bao giờ trả lại đầy đủ.
  await expect(page.getByText("Đã lưu •••• 4521 · để trống nếu không đổi")).toBeVisible();
  await expect(page.getByLabel("Số tài khoản *")).toHaveValue("");

  // Tải lại trang (token đã cất trong tab): dữ liệu còn nguyên.
  await page.reload();
  await expect(page.getByLabel("Mã số thuế *")).toHaveValue("0312345678");
  await expect(page.getByLabel("Hotline *")).toHaveValue("19006868");

  // Xem giấy tờ: mở tab mới tới URL tải về có hạn của kho riêng tư.
  const popupPromise = page.waitForEvent("popup");
  await page.getByRole("button", { name: "Xem Giấy phép kinh doanh vận tải" }).click();
  const popup = await popupPromise;
  await popup.waitForURL(/\/v1\/dev-storage\/download\?token=/);
  await popup.close();
});

test("gửi duyệt → trang Chờ duyệt (bước 4) với lịch sử hồ sơ; hồ sơ đã gửi chỉ xem được", async () => {
  await page.getByRole("button", { name: "Gửi duyệt" }).click();
  await expect(page.getByText("Hồ sơ đang chờ Vé Xe Nhanh duyệt")).toBeVisible();
  await expect(page.getByRole("listitem").filter({ hasText: "Chờ duyệt" })).toHaveAttribute("aria-current", "step");
  const history = page.getByRole("list", { name: "Lịch sử hồ sơ" });
  await expect(history).toContainText("Đã gửi duyệt");
  await expect(history).toContainText("Đã xác minh email");
  await expect(history).toContainText("Đã gửi đăng ký");
  await expect(page.getByRole("button", { name: "Lưu nháp" })).toHaveCount(0);

  await page.getByRole("button", { name: "Xem hồ sơ đã gửi" }).click();
  await expect(page.getByText("Vietcombank · •••• 4521 · CTY TNHH SAO VIET")).toBeVisible();
  await expect(page.getByRole("list", { name: "Giấy tờ đã gửi" })).toContainText("gpkd.pdf");
});

test("link sai → trang 'Link không còn hiệu lực'; gửi lại link bằng email + mã hồ sơ; link cũ hết hiệu lực", async () => {
  await page.goto(`/register/application#token=${"A".repeat(43)}`);
  await expect(page.getByRole("heading", { name: "Link không còn hiệu lực" })).toBeVisible();
  await expect(page).toHaveURL(/\/register\/resend\?reason=invalid$/);

  await page.getByLabel("Email liên hệ *").fill(email);
  await page.getByLabel("Mã hồ sơ *").fill(applicationCode.toLowerCase());
  await page.getByRole("button", { name: "Gửi lại link" }).click();
  await expect(page.getByRole("heading", { name: "Kiểm tra hộp thư của bạn" })).toBeVisible();

  // Gửi lại link thu hồi link trước đó.
  await page.goto(`/register/application#token=${token}`);
  await expect(page.getByRole("heading", { name: "Link không còn hiệu lực" })).toBeVisible();
});
