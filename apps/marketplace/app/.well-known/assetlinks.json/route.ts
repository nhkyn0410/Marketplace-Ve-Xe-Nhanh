import { androidAssetLinks } from "../../../lib/app-links/asset-links";

// Đọc biến môi trường lúc chạy (bản build Docker chỉ có env khi khởi động), không đóng băng lúc build.
export const dynamic = "force-dynamic";

/** Digital Asset Links cho App Link của app hành khách (PASSENGER-PARITY A25). */
export function GET(): Response {
  return Response.json(androidAssetLinks(process.env.ANDROID_APP_PACKAGE, process.env.ANDROID_APP_CERT_SHA256), {
    headers: { "Cache-Control": "public, max-age=3600" }
  });
}
