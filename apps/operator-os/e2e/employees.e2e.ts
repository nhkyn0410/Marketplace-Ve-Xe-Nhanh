import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment, totp } from "./helpers";

// Màn Nhân viên + màn Tài khoản của chủ nhà xe (UC-16, FR-IAM-15; API của TASK-IAM-005). Chạy tuần tự, dùng chung
// một phiên: tạo nhân viên (thao tác nhạy cảm → xác nhận lại danh tính bằng mật khẩu), khóa / mở khóa, cấp lại
// mật khẩu tạm, sửa vai trò, rồi thu hồi một phiên đăng nhập ở trình duyệt khác.
// API của E2E PHẢI chạy với `RESEND_API_KEY` để trống để không gửi email thật. Khi đó bộ gửi email của bản dev
// từ chối gửi mật khẩu tạm, nên tạo / cấp lại luôn trả 503 "chưa gửi được" — spec kiểm đúng nhánh đó (tài khoản
// vẫn được tạo, có hướng dẫn cấp lại). Nhánh gửi thành công cần email thật, chỉ kiểm được bằng tay.
test.describe.configure({ mode: "serial" });

// Lần đầu mở một trang, máy chủ dev của Next phải biên dịch trang đó — có thể lâu hơn 5 giây mặc định.
const FIRST_VISIT = { timeout: 30_000 };
const IDENTITY = "Mật khẩu của bạn hoặc mã xác thực *";
let page: Page;
let identifier: string;
let password: string;
let totpSecret: string;
/** Tên đăng nhập đầy đủ của nhân viên seed sẵn (tài xế, chưa có email) và nhân viên tạo trong spec. */
let seededLogin: string;
let createdLogin: string;

test.beforeAll(async ({ browser }) => {
  const { operatorSlug, staffOwner, employee } = accounts();
  identifier = `${operatorSlug}/${staffOwner.username}`;
  password = staffOwner.password;
  seededLogin = `${operatorSlug}/${employee.username}`;
  createdLogin = `${operatorSlug}/nv.ve.lan`;
  page = await browser.newPage();
  totpSecret = await signInWithEnrollment(page, identifier, password);
});

test.afterAll(async () => {
  await page.close();
});

const row = (login: string) => page.getByRole("row").filter({ hasText: login });
const dialog = () => page.getByRole("dialog");
const notice = (text: string) => page.getByRole("status").filter({ hasText: text });

test("thêm nhân viên: lỗi báo tại ô, xác nhận sai mật khẩu không bị đăng xuất, tạo xong mà chưa gửi được mật khẩu tạm thì có hướng dẫn", async () => {
  await page.getByRole("link", { name: "Nhân viên", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Nhân viên", level: 1 })).toBeVisible(FIRST_VISIT);
  // Nhân viên seed sẵn: tài xế, đã có mật khẩu riêng, chưa có email liên hệ.
  await expect(row(seededLogin)).toContainText("Tài xế");
  await expect(row(seededLogin)).toContainText("Hoạt động");
  await expect(row(seededLogin)).toContainText("Đã đổi mật khẩu");
  await expect(row(seededLogin)).toContainText("Chưa có email liên hệ");
  await expect(page.getByText("Đã tải 1 nhân viên")).toBeVisible();

  await page.getByRole("button", { name: "Thêm nhân viên" }).click();
  await expect(dialog().getByRole("heading", { name: "Thêm nhân viên" })).toBeVisible();
  // Tiền tố tên đăng nhập cố định theo mã nhà xe.
  await expect(dialog()).toContainText(`${accounts().operatorSlug}/nv.`);

  // Bấm tạo khi còn trống: lỗi nằm tại từng ô, kể cả ô xác nhận danh tính; chưa gọi máy chủ.
  await dialog().getByRole("button", { name: "Tạo tài khoản" }).click();
  await expect(dialog().getByText(/Tên đăng nhập chưa hợp lệ/)).toBeVisible();
  await expect(dialog().getByText("Nhập email liên hệ hợp lệ.")).toBeVisible();
  await expect(dialog().getByText("Chọn vai trò của nhân viên.")).toBeVisible();
  await expect(dialog().getByText("Nhập mật khẩu của bạn hoặc mã xác thực 6 số.")).toBeVisible();

  await dialog().getByLabel("Tên đăng nhập *").fill("ve.lan");
  await dialog().getByLabel("Email liên hệ *").fill("lan.ve@example.com");
  await dialog().getByRole("radio", { name: /Nhân viên bán vé/ }).check();

  // Sai mật khẩu xác nhận: báo tại ô, phiên đăng nhập vẫn còn (không bị coi là hết phiên).
  await dialog().getByLabel(IDENTITY).fill("mat-khau-sai-0000");
  await dialog().getByRole("button", { name: "Tạo tài khoản" }).click();
  await expect(dialog().getByText("Mật khẩu hoặc mã xác thực không đúng.")).toBeVisible();
  await expect(dialog().getByLabel("Tên đăng nhập *")).toHaveValue("ve.lan");

  await dialog().getByLabel(IDENTITY).fill(password);
  await dialog().getByRole("button", { name: "Tạo tài khoản" }).click();
  // Bản dev không gửi được email: tài khoản vẫn được tạo, hộp thoại dặn không tạo lại mà cấp lại mật khẩu.
  await expect(dialog().getByRole("alert")).toContainText("Chưa gửi được mật khẩu tạm");
  await expect(dialog().getByRole("alert")).toContainText("không tạo lại tài khoản");
  await dialog().getByRole("button", { name: "Hủy" }).click();
  await expect(dialog()).toHaveCount(0);
  await expect(row(createdLogin)).toContainText("Nhân viên bán vé");
  await expect(row(createdLogin)).toContainText("Chưa gửi được mật khẩu tạm");
  await expect(row(createdLogin)).toContainText("Bấm cấp lại mật khẩu để gửi lại");
  await expect(page.getByText("Đã tải 2 nhân viên")).toBeVisible();
});

test("trùng tên đăng nhập báo tại ô, trong 5 phút không hỏi lại mật khẩu; tìm và lọc danh sách", async () => {
  await page.getByRole("button", { name: "Thêm nhân viên" }).click();
  // Vừa xác nhận danh tính ở ca trước nên ô mật khẩu không hiện lại.
  await expect(dialog().getByLabel(IDENTITY)).toHaveCount(0);
  await dialog().getByLabel("Tên đăng nhập *").fill("ve.lan");
  await dialog().getByLabel("Email liên hệ *").fill("lan2.ve@example.com");
  await dialog().getByRole("radio", { name: /Tài xế/ }).check();
  await dialog().getByRole("button", { name: "Tạo tài khoản" }).click();
  await expect(dialog().getByText("Tên đăng nhập này đã có trong nhà xe. Chọn tên khác.")).toBeVisible();
  await dialog().getByRole("button", { name: "Hủy" }).click();
  await expect(dialog()).toHaveCount(0);

  await page.getByLabel("Tìm nhân viên").fill("LAN.VE@");
  await expect(row(createdLogin)).toBeVisible();
  await expect(row(seededLogin)).toHaveCount(0);
  await expect(page.getByText("Đang hiển thị 1 / 2 nhân viên")).toBeVisible();
  await page.getByLabel("Vai trò", { exact: true }).click();
  await page.getByRole("option", { name: "Tài xế" }).click();
  await expect(page.getByText("Không có nhân viên phù hợp")).toBeVisible();
  await page.getByRole("button", { name: "Bỏ lọc" }).click();
  await expect(page.getByText("Đã tải 2 nhân viên")).toBeVisible();
});

test("khóa / mở khóa bắt buộc lý do; cấp lại mật khẩu tạm: gửi lỗi thì báo rõ, lần hai trong giờ bị chặn; sửa vai trò", async () => {
  await page.getByRole("button", { name: `Khóa ${createdLogin}` }).click();
  await expect(dialog().getByRole("heading", { name: "Khóa tài khoản nhân viên" })).toBeVisible();
  await dialog().getByRole("button", { name: "Khóa tài khoản" }).click();
  await expect(dialog().getByText("Nhập lý do, ít nhất 3 ký tự.")).toBeVisible();
  await dialog().getByLabel("Lý do *").fill("Tạm nghỉ việc hai tuần.");
  await dialog().getByRole("button", { name: "Khóa tài khoản" }).click();
  await expect(notice(`Đã khóa ${createdLogin}`)).toBeVisible();
  await expect(row(createdLogin)).toContainText("Bị khóa");
  await expect(row(createdLogin)).toContainText("Tài khoản đang bị khóa");

  await page.getByRole("button", { name: `Mở khóa ${createdLogin}` }).click();
  await dialog().getByLabel("Lý do *").fill("Đi làm lại.");
  await dialog().getByRole("button", { name: "Mở khóa" }).click();
  await expect(notice(`Đã mở khóa ${createdLogin}`)).toBeVisible();
  await expect(row(createdLogin)).toContainText("Hoạt động");

  // Cấp lại mật khẩu tạm: bản dev không gửi được email nên lần đầu báo "chưa gửi được" (mật khẩu cũ đã bị
  // thay, lượt của giờ này đã tính); bấm lại ngay thì máy chủ chặn vì mỗi nhân viên một lần mỗi giờ.
  await page.getByRole("button", { name: `Cấp lại mật khẩu tạm cho ${createdLogin}` }).click();
  await expect(dialog()).toContainText("Mật khẩu tạm mới được gửi tới lan.ve@example.com");
  await dialog().getByLabel("Lý do *").fill("Nhân viên báo chưa nhận được email.");
  await dialog().getByRole("button", { name: "Cấp lại mật khẩu" }).click();
  await expect(dialog().getByRole("alert")).toContainText("Chưa gửi được mật khẩu tạm mới");
  await dialog().getByRole("button", { name: "Cấp lại mật khẩu" }).click();
  await expect(dialog().getByRole("alert")).toContainText("mỗi nhân viên cấp lại tối đa một lần mỗi giờ");
  await dialog().getByRole("button", { name: "Hủy" }).click();

  // Nhân viên chưa có email thì chưa có nơi nhận mật khẩu tạm.
  await page.getByRole("button", { name: `Cấp lại mật khẩu tạm cho ${seededLogin}` }).click();
  await expect(dialog().getByRole("alert")).toContainText("chưa có email liên hệ");
  await dialog().getByRole("button", { name: "Đã hiểu" }).click();

  // Sửa: không đổi gì thì không gửi; đổi vai trò thì dòng trong bảng đổi theo.
  await page.getByRole("button", { name: `Sửa ${createdLogin}` }).click();
  await expect(dialog().getByLabel("Tên đăng nhập *")).toHaveValue("ve.lan");
  await dialog().getByLabel("Lý do thay đổi *").fill("Chuyển sang lái xe.");
  await dialog().getByRole("button", { name: "Lưu thay đổi" }).click();
  await expect(dialog().getByText("Chưa có thay đổi nào để lưu.")).toBeVisible();
  await dialog().getByRole("radio", { name: /Tài xế/ }).check();
  await dialog().getByRole("button", { name: "Lưu thay đổi" }).click();
  await expect(notice(`Đã cập nhật ${createdLogin}`)).toBeVisible();
  await expect(row(createdLogin)).toContainText("Tài xế");
});

test("màn Tài khoản: thấy phiên đang dùng; thu hồi phiên ở trình duyệt khác thì trình duyệt đó về màn đăng nhập", async ({ browser }) => {
  test.setTimeout(150_000);
  await page.getByRole("link", { name: "Tài khoản và bảo mật" }).click();
  await expect(page.getByRole("heading", { name: "Tài khoản và bảo mật", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText(`${identifier} · Chủ nhà xe`)).toBeVisible();
  const sessions = page.getByRole("region", { name: "Phiên đăng nhập" }).getByRole("row");
  // Một dòng tiêu đề + đúng một phiên: phiên đang dùng.
  await expect(sessions).toHaveCount(2);
  await expect(sessions.nth(1)).toContainText("Phiên hiện tại");
  await expect(sessions.nth(1)).toContainText("Đang dùng");
  const revokeOthers = page.getByRole("button", { name: "Đăng xuất các phiên khác" });
  await expect(revokeOthers).toBeDisabled();
  await expect(page.getByRole("region", { name: "Xác thực hai lớp" })).toContainText("Đang bật");

  // Đăng nhập thêm ở một trình duyệt khác. Mã TOTP dùng lúc bật xác thực không dùng lại được nên chờ sang
  // chu kỳ 30 giây kế tiếp.
  await page.waitForTimeout(30_000 - (Date.now() % 30_000) + 1_000);
  const other = await (await browser.newContext()).newPage();
  await other.goto("/");
  await other.locator('input[name="identifier"]').fill(identifier);
  await other.locator('input[name="password"]').fill(password);
  await other.getByRole("button", { name: "Đăng nhập", exact: true }).click();
  await other.locator('input[name="code"]').fill(totp(totpSecret));
  await other.getByRole("button", { name: "Xác nhận" }).click();
  await expect(other.getByRole("navigation", { name: "Điều hướng chính" })).toBeVisible(FIRST_VISIT);

  await page.reload();
  await expect(sessions).toHaveCount(3);
  await expect(revokeOthers).toBeEnabled();
  await page.getByRole("button", { name: /^Thu hồi phiên/ }).click();
  await expect(notice("Đã thu hồi phiên. Thiết bị đó đã bị đăng xuất.")).toBeVisible();
  await expect(sessions).toHaveCount(2);

  // Trình duyệt kia gọi API lần tới thì bị từ chối và quay về màn đăng nhập.
  await other.getByRole("link", { name: "Phương tiện", exact: true }).click();
  await expect(other.getByRole("heading", { name: "Phiên đăng nhập đã hết hạn" })).toBeVisible(FIRST_VISIT);
  await other.context().close();
});
