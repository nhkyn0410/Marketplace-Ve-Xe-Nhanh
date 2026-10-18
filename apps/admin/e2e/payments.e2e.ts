import { expect, test, type Locator, type Page } from "@playwright/test";

import { accounts, signInPlatform, totp } from "./helpers";

// TASK-ADM-002 (màn Thanh toán & hoàn tiền, Figma ADM-07a–d) — đơn đã xác nhận của nhà xe đặt vé do global-setup seed có thanh
// toán thành công (vé + sổ giữ hộ) và hai thanh toán trùng cần đối soát: một khoản chưa xử lý, một khoản có hoàn tiền thất bại
// (cổng trả lỗi 91). Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let secret: string;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;

test.beforeAll(async ({ browser }) => {
  const { bookingFixtures, platformPayments } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Thanh toán & hoàn tiền (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  secret = await signInPlatform(page, platformPayments);
});

test.afterAll(async () => {
  await page.close();
});

/** Mở tab rồi tìm trong vùng của tab đó (đợi tab chuyển xong — tránh điền vào ô của tab cũ). */
async function searchIn(tab: RegExp | string, region: string, text: string): Promise<Locator> {
  await page.getByRole("tab", { name: tab }).click();
  const scope = page.getByRole("region", { name: region });
  await expect(scope).toBeVisible(FIRST_VISIT);
  await scope.getByLabel("Tìm kiếm").fill(text);
  return scope;
}

/** Điền mã TOTP nếu ô đang hiện (5 phút sau lần xác nhận trước thì không hỏi lại). */
async function fillTotp(scope: Locator | Page) {
  const code = scope.getByLabel("Mã xác thực (TOTP) *");
  if (await code.isVisible()) {
    await code.fill(totp(secret, Date.now() + 30_000));
  }
}

test("thanh toán: tìm theo mã đặt vé → thành công + 2 khoản cần đối soát; chi tiết có dòng thời gian, phân bổ theo sổ, cổng", async () => {
  await page.getByRole("link", { name: "Thanh toán & hoàn tiền" }).click();
  await expect(page.getByRole("heading", { name: "Thanh toán & hoàn tiền", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByLabel("Tìm kiếm").fill(fixtures.confirmedCode);
  const rows = page.getByRole("row");
  await expect(rows).toHaveCount(4, FIRST_VISIT);
  await expect(rows.filter({ hasText: fixtures.reconcilePaymentCode })).toContainText("Trả trùng cho cùng đơn");
  const success = rows.filter({ hasText: "Thành công" });
  await expect(success).toContainText("600.000");
  await expect(success).toContainText(fixtures.operatorName);
  await success.getByRole("link", { name: "Xem" }).click();

  await expect(page.getByRole("heading", { name: /^Thanh toán PAY/, level: 1 })).toBeVisible(FIRST_VISIT);
  const timeline = page.getByRole("region", { name: "Dòng thời gian giao dịch" });
  await expect(timeline).toContainText("Phát hành 2 vé");
  await expect(timeline).toContainText("Ghi sổ giữ hộ");
  await expect(timeline).toContainText("Đủ điều kiện chi trả cho nhà xe");
  const allocation = page.getByRole("region", { name: "Phân bổ số tiền" });
  await expect(allocation).toContainText("Hoa hồng 5% trên giá vé");
  await expect(allocation).toContainText("570.000");
  await expect(page.getByRole("region", { name: "Cổng thanh toán" })).toContainText("Khớp");
  await expect(page.getByRole("region", { name: "Hoàn tiền" })).toContainText("Chưa có yêu cầu hoàn tiền");
  await expect(page.getByRole("button", { name: "Hoàn toàn bộ cho khách" })).toHaveCount(0);
});

test("cần đối soát: khoản trả trùng → hoàn toàn bộ cho khách (lý do + TOTP) → yêu cầu hoàn đã tạo, khoản rời tab", async () => {
  await page.getByRole("link", { name: "Quay lại danh sách giao dịch" }).click();
  const list = await searchIn(/Cần đối soát/, "Thanh toán cần đối soát", fixtures.confirmedCode);
  const row = list.getByRole("row").filter({ hasText: fixtures.reconcilePaymentCode });
  await expect(row).toContainText("Cần đối soát", FIRST_VISIT);
  await row.getByRole("link", { name: "Xử lý" }).click();

  await expect(page.getByRole("heading", { name: `Thanh toán ${fixtures.reconcilePaymentCode}` })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("note")).toContainText("Trả trùng cho cùng đơn");
  await page.getByRole("button", { name: "Hoàn toàn bộ cho khách" }).click();
  const dialog = page.getByRole("dialog");
  await expect(dialog).toContainText("600.000");
  await dialog.getByLabel("Lý do và căn cứ *").fill("Khách trả hai lần cho cùng đơn (E2E)");
  await fillTotp(dialog);
  await dialog.getByRole("button", { name: "Tạo hoàn tiền" }).click();
  await expect(dialog).toBeHidden();
  await expect(page.getByRole("status")).toContainText("Đã tạo yêu cầu hoàn RFD");
  await expect(page.getByRole("region", { name: "Hoàn tiền" })).toContainText(/Chờ gửi cổng|Đang hoàn|Thành công/);
  await expect(page.getByRole("button", { name: "Hoàn toàn bộ cho khách" })).toHaveCount(0);

  await page.getByRole("link", { name: "Quay lại danh sách giao dịch" }).click();
  const after = await searchIn(/Cần đối soát/, "Thanh toán cần đối soát", fixtures.reconcilePaymentCode);
  await expect(after.getByText("Không có giao dịch phù hợp")).toBeVisible(FIRST_VISIT);
});

test("hoàn tiền thất bại → Xử lý → ghi nhận đã hoàn ngoài cổng (mã tham chiếu + lý do + TOTP) → thành công", async () => {
  const list = await searchIn("Hoàn tiền", "Yêu cầu hoàn tiền", fixtures.failedRefundCode);
  const row = list.getByRole("row").filter({ hasText: fixtures.failedRefundCode });
  await expect(row).toContainText("Thất bại", FIRST_VISIT);
  await expect(row).toContainText("Cổng VNPay trả lỗi 91");
  await expect(row).toContainText("Vé Xe Nhanh (đối soát)");
  await row.getByRole("button", { name: `Xử lý ${fixtures.failedRefundCode}` }).click();

  const dialog = page.getByRole("dialog");
  await expect(dialog.getByRole("heading", { name: "Xử lý hoàn tiền" })).toBeVisible(FIRST_VISIT);
  await expect(dialog).toContainText("Lỗi gần nhất của cổng");
  await dialog.getByRole("radio", { name: /^Đã hoàn ngoài cổng/ }).check();
  await dialog.getByLabel("Mã tham chiếu *").fill("FT26291000077");
  await dialog.getByLabel("Lý do và căn cứ *").fill("Đã chuyển khoản tay cho khách (E2E)");
  await fillTotp(dialog);
  await dialog.getByRole("button", { name: "Xác nhận xử lý" }).click();
  await expect(dialog.getByRole("status")).toContainText(`Đã ghi nhận ${fixtures.failedRefundCode} đã hoàn`);
  await dialog.getByRole("button", { name: "Đóng", exact: true }).last().click();
  await expect(dialog).toBeHidden();
  await expect(row).toContainText("Thành công");

  await row.getByRole("button", { name: `Xem ${fixtures.failedRefundCode}` }).click();
  await expect(dialog).toContainText("FT26291000077");
  await expect(dialog.getByRole("region", { name: "Tiến trình hoàn tiền" })).toContainText("Đã chuyển khoản tay cho khách (E2E)");
});
