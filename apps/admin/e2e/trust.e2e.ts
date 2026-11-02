import { expect, test, type Locator, type Page } from "@playwright/test";

import { accounts, signInPlatform, totp } from "./helpers";

// TASK-TRUST-001 (Khiếu nại & tranh chấp ADM-09a–e, Kiểm duyệt đánh giá ADM-10a) — nhà xe đặt vé do global-setup seed: khiếu nại mới
// chưa phân loại, đánh giá 4 sao của đơn chuyến đã chạy. Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let secret: string;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;

test.beforeAll(async ({ browser }) => {
  const { bookingFixtures, platformTrust } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Khiếu nại & tranh chấp (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  secret = await signInPlatform(page, platformTrust);
});

test.afterAll(async () => {
  await page.close();
});

/** Điền mã TOTP nếu ô đang hiện (5 phút sau lần xác nhận trước thì không hỏi lại). */
async function fillTotp(scope: Locator) {
  const code = scope.getByLabel("Mã xác thực (TOTP) *");
  if (await code.isVisible()) {
    await code.fill(totp(secret, Date.now() + 30_000));
  }
}

test("khiếu nại mới: tìm theo mã → phân loại chuyển nhà xe (Chờ nhà xe) → trả lời khách", async () => {
  await page.getByRole("link", { name: "Khiếu nại & tranh chấp", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Khiếu nại & tranh chấp", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("tab", { name: /Khiếu nại \(\d+ chưa phân loại\)/ })).toBeVisible(FIRST_VISIT);
  const list = page.getByRole("region", { name: "Khiếu nại" });
  await list.getByLabel("Tìm kiếm").fill(fixtures.newTicketCode);
  const row = list.getByRole("row").filter({ hasText: fixtures.newTicketCode });
  await expect(row).toContainText("Mới", FIRST_VISIT);
  await expect(row).toContainText("Khách vãng lai");
  await row.getByRole("link", { name: `Xem ${fixtures.newTicketCode}` }).click();

  await expect(page.getByRole("heading", { name: fixtures.newTicketSubject })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Dữ liệu liên quan" })).toContainText("2 vé hợp lệ");
  await page.getByRole("combobox", { name: "Bên xử lý chính *" }).click();
  await page.getByRole("option", { name: "Nhà xe", exact: true }).click();
  await page.getByRole("button", { name: "Lưu phân loại" }).click();
  await expect(page.getByRole("status")).toContainText("chuyển nhà xe phản hồi", FIRST_VISIT);
  await expect(page.getByText("Chờ nhà xe", { exact: true })).toBeVisible();

  await page.getByLabel("Phản hồi cho hành khách").fill("Vé Xe Nhanh đang kiểm tra giao dịch với cổng thanh toán.");
  await page.getByRole("button", { name: "Gửi phản hồi" }).click();
  await expect(page.getByRole("status")).toContainText("Đã gửi phản hồi cho khách", FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Trao đổi" })).toContainText("Vé Xe Nhanh đang kiểm tra giao dịch");
});

test("chuyển tranh chấp → yêu cầu minh chứng nhà xe → đang xem xét → quyết định không hoàn (lý do + TOTP) → đóng", async () => {
  await page.getByRole("button", { name: "Chuyển thành tranh chấp" }).click();
  const open = page.getByRole("dialog");
  await open.getByLabel("Yêu cầu của khách").fill("Hoàn tiền giao dịch bị trừ lần hai");
  await open.getByLabel("Lý do chuyển *").fill("Cần đối chiếu minh chứng hai bên (E2E)");
  await open.getByRole("button", { name: "Mở tranh chấp" }).click();
  await expect(page).toHaveURL(/\/disputes\/cases\/[0-9a-f-]{36}/, FIRST_VISIT);
  await expect(page.getByRole("heading", { name: /^Tranh chấp DC-\d{6,}$/ })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Tóm tắt" })).toContainText("Hoàn tiền giao dịch bị trừ lần hai");

  await page.getByRole("button", { name: "Yêu cầu minh chứng" }).click();
  const request = page.getByRole("dialog");
  await request.getByLabel("Nội dung yêu cầu *").fill("Gửi sao kê đối chiếu của nhà xe");
  await request.getByRole("button", { name: "Gửi yêu cầu" }).click();
  await expect(page.getByRole("status")).toContainText("Đã yêu cầu nhà xe", FIRST_VISIT);
  await expect(page.getByText("Chờ nhà xe phản hồi", { exact: true }).first()).toBeVisible();

  await page.getByRole("button", { name: "Đổi trạng thái" }).click();
  const status = page.getByRole("dialog");
  await status.getByLabel("Lý do *").fill("Đủ dữ liệu từ cổng để xem xét");
  await status.getByRole("button", { name: "Xác nhận" }).click();
  await expect(page.getByRole("status")).toContainText("Đang xem xét", FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Lịch sử trạng thái" })).toContainText("Yêu cầu minh chứng của nhà xe");

  await page.getByRole("button", { name: "Ra quyết định" }).click();
  const decide = page.getByRole("dialog");
  await decide.getByText("Không hoàn tiền", { exact: true }).click();
  await decide.getByLabel("Lý do và căn cứ *").fill("Cổng chỉ ghi nhận một giao dịch thành công");
  await fillTotp(decide);
  await decide.getByRole("button", { name: "Xác nhận quyết định" }).click();
  await expect(decide).toBeHidden(FIRST_VISIT);
  await expect(page.getByText("Đã quyết định · không hoàn", { exact: true }).first()).toBeVisible();
  await expect(page.getByRole("note").first()).toContainText("Không hoàn tiền");

  await page.getByRole("button", { name: "Đóng tranh chấp" }).click();
  const close = page.getByRole("dialog");
  await close.getByLabel("Lý do *").fill("Đã thông báo kết quả cho các bên");
  await close.getByRole("button", { name: "Xác nhận" }).click();
  await expect(page.getByText("Đã đóng", { exact: true }).first()).toBeVisible(FIRST_VISIT);
});

test("kiểm duyệt đánh giá: tab mặc định; lọc nhà xe → ẩn cần lý do → Đã ẩn", async () => {
  await page.getByRole("link", { name: "Kiểm duyệt", exact: true }).click();
  await expect(page.getByRole("tab", { name: "Đánh giá" })).toHaveAttribute("aria-selected", "true", FIRST_VISIT);
  const section = page.getByRole("region", { name: "Đánh giá" });
  await section.getByRole("combobox", { name: "Tình trạng" }).click();
  await page.getByRole("option", { name: "Tất cả", exact: true }).click();
  await section.getByLabel("Tìm kiếm").fill(fixtures.reviewComment);
  const row = section.getByRole("row").filter({ hasText: fixtures.reviewComment });
  await expect(row).toContainText("Đang hiển thị", FIRST_VISIT);
  await row.getByRole("button", { name: "Ẩn" }).click();
  const dialog = page.getByRole("dialog");
  await dialog.getByRole("button", { name: "Ẩn đánh giá" }).click();
  await expect(dialog.getByRole("alert")).toContainText("Nhập lý do");
  await dialog.getByLabel("Lý do *").fill("Nội dung kiểm thử E2E");
  await dialog.getByRole("button", { name: "Ẩn đánh giá" }).click();
  await expect(page.getByRole("status")).toContainText("Đã ẩn đánh giá", FIRST_VISIT);
  await expect(row).toContainText("Đã ẩn");
});
