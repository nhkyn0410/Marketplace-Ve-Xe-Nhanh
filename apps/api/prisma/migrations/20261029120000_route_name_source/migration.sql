-- Tên tuyến tự động (giai đoạn 3.1, tự thiết kế 29/10/2026, chờ duyệt): `AUTO` = hệ thống ghép từ nơi của các điểm dừng,
-- `MANUAL` = nhà xe gõ tay. Tuyến đang có giữ `MANUAL` để không tự đổi tên trên vé đã bán.
CREATE TYPE "RouteNameSource" AS ENUM ('AUTO', 'MANUAL');

ALTER TABLE "routes" ADD COLUMN "name_source" "RouteNameSource" NOT NULL DEFAULT 'MANUAL';
