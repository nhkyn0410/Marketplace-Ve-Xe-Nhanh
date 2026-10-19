import { expect, test, type Locator, type Page } from "@playwright/test";

import { accounts, signInPlatform, totp } from "./helpers";

// TASK-BTP-006 / ADM-002 (màn Chi trả nhà xe, Figma ADM-08a–c) — kỳ chờ rà soát của nhà xe đặt vé do global-setup seed
// (427.500 ₫ = 450.000 − hoa hồng 5%, tài khoản Vietcombank đã xác minh). Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let secret: string;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;

test.beforeAll(async ({ browser }) => {
  const { bookingFixtures, platformFinance } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Chi trả (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  secret = await signInPlatform(page, platformFinance);
});

test.afterAll(async () => {
  await page.close();
});

/** Điền mã TOTP nếu ô đang hiện (5 phút sau lần xác nhận trước thì không hỏi lại). */
async function fillTotp(scope: Locator | Page) {
  const code = scope.getByLabel("Mã xác thực (TOTP) *");
  if (await code.isVisible()) {
    await code.fill(totp(secret, Date.now() + 30_000));
  }
}

test("danh sách: kỳ của nhà xe chờ rà soát, tài khoản che số; mở rà soát", async () => {
  await page.getByRole("link", { name: "Chi trả nhà xe", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Chi trả nhà xe", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByLabel("Tìm kiếm").fill(fixtures.payoutCode);
  const row = page.getByRole("row").filter({ hasText: fixtures.payoutCode });
  await expect(row).toContainText(fixtures.operatorName, FIRST_VISIT);
  await expect(row).toContainText("427.500");
  await expect(row).toContainText("Vietcombank •• 4521");
  await expect(row).toContainText("Chờ rà soát");
  await row.getByRole("link", { name: "Rà soát" }).click();
  await expect(page.getByRole("heading", { name: `Chi trả ${fixtures.payoutCode}` })).toBeVisible(FIRST_VISIT);
  await expect(page.getByRole("region", { name: "Kiểm tra trước khi chi" })).toContainText("Số liệu khớp sổ giữ hộ");
});

test("rà soát xong → sẵn sàng; xác nhận đã chuyển khoản (mã giao dịch + ghi chú + TOTP) → đã chi trả; xem đầy đủ số tài khoản", async () => {
  await page.getByRole("button", { name: "Rà soát xong" }).click();
  await expect(page.getByRole("status")).toContainText("sẵn sàng chuyển khoản");
  await page.getByRole("button", { name: "Xác nhận đã chuyển khoản" }).click();
  const dialog = page.getByRole("dialog");
  await expect(dialog).toContainText("427.500");
  await dialog.getByLabel("Mã giao dịch ngân hàng *").fill("FT26286104552");
  await dialog.getByLabel("Ghi chú xác nhận *").fill("Đã chuyển theo lệnh chi E2E");
  await fillTotp(dialog);
  await dialog.getByRole("button", { name: "Xác nhận đã chi trả" }).click();
  await expect(dialog).toBeHidden();
  await expect(page.getByRole("status")).toContainText(`Đã xác nhận chi trả ${fixtures.payoutCode}`);
  await expect(page.getByRole("region", { name: "Tiến trình" })).toContainText("Mã giao dịch ngân hàng: FT26286104552");

  const bank = page.getByRole("region", { name: "Tài khoản nhận tiền" });
  const reveal = bank.getByRole("button", { name: "Hiện đầy đủ số tài khoản" });
  await reveal.click();
  // Vừa xác nhận danh tính (5 phút) thì không hỏi lại TOTP; nếu ô hiện thì điền rồi bấm lại.
  if (await bank.getByLabel("Mã xác thực (TOTP) *").isVisible()) {
    await fillTotp(bank);
    await reveal.click();
  }
  await expect(bank).toContainText("0071000124521");
});
