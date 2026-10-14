// Token của link bảo mật (BR-75). Link trong email có dạng `/register/application#token=…`: phần sau `#` không
// gửi lên máy chủ web, không lọt vào log / Referer. Trang đọc token một lần, cất vào sessionStorage của tab rồi xóa
// khỏi thanh địa chỉ để không bị lộ khi chia sẻ màn hình / lịch sử trình duyệt.
const STORAGE_KEY = "vxn_application_token";

/** Lấy token: ưu tiên token mới trong `#token=` của URL, sau đó token đã cất của tab. */
export function takeApplicationToken(location: Pick<Location, "hash">, history: Pick<History, "replaceState">): string | null {
  const match = /(?:^#|&)token=([A-Za-z0-9_-]+)/.exec(location.hash);
  if (match) {
    try {
      sessionStorage.setItem(STORAGE_KEY, match[1]!);
    } catch {
      // Chế độ riêng tư chặn storage: vẫn dùng được token cho lần tải trang này.
    }
    history.replaceState(null, "", "/register/application");
    return match[1]!;
  }
  try {
    return sessionStorage.getItem(STORAGE_KEY);
  } catch {
    return null;
  }
}

/** Quên token khi link đã hết hiệu lực. */
export function forgetApplicationToken(): void {
  try {
    sessionStorage.removeItem(STORAGE_KEY);
  } catch {
    // Không có storage thì không có gì để xóa.
  }
}
