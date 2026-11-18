/** Một khai báo Digital Asset Links cho app Android. */
export interface AndroidAssetLink {
  readonly relation: readonly ["delegate_permission/common.handle_all_urls"];
  readonly target: {
    readonly namespace: "android_app";
    readonly package_name: string;
    readonly sha256_cert_fingerprints: readonly string[];
  };
}

const PACKAGE_NAME = /^[A-Za-z][\w]*(\.[A-Za-z][\w]*)+$/;
const FINGERPRINT = /^([0-9A-F]{2}:){31}[0-9A-F]{2}$/;

/**
 * Nội dung `/.well-known/assetlinks.json` (PASSENGER-PARITY A25): khai app hành khách được mở các App Link của web
 * (cổng thanh toán quay về `/app/bookings/{id}/payment/result`). Gói và vân tay SHA-256 khóa ký lấy từ biến môi
 * trường; thiếu hoặc sai dạng thì trả danh sách rỗng — Android không mở app, link vẫn mở trên web.
 */
export function androidAssetLinks(packageName: string | undefined, fingerprints: string | undefined): readonly AndroidAssetLink[] {
  const name = (packageName ?? "").trim();
  const certs = (fingerprints ?? "")
    .split(",")
    .map((value) => value.trim().toUpperCase())
    .filter((value) => FINGERPRINT.test(value));
  if (!PACKAGE_NAME.test(name) || certs.length === 0) return [];
  return [
    {
      relation: ["delegate_permission/common.handle_all_urls"],
      target: { namespace: "android_app", package_name: name, sha256_cert_fingerprints: certs }
    }
  ];
}
