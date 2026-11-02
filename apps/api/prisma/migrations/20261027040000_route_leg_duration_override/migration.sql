-- Thời gian chạy của chuyến gắn với tuyến (Khanh 27/10/2026, chờ duyệt): giờ đến = giờ đi + tổng thời gian các chặng.
-- Nhà xe được chỉnh thời gian từng chặng thành thời gian xe khách chạy thật; cột mới giữ số hệ thống tính (Goong /
-- ước lượng) để xem lại và quay về số hệ thống. Dữ liệu cũ: mọi chặng đều là số hệ thống.

SET LOCAL lock_timeout = '10s';

ALTER TABLE "route_stops" ADD COLUMN "measured_duration_seconds" INTEGER;
UPDATE "route_stops" SET "measured_duration_seconds" = "duration_seconds_from_previous";

ALTER TABLE "route_stops" ADD CONSTRAINT "route_stops_measured_duration_consistent" CHECK (
  ("sequence" = 1) = ("measured_duration_seconds" IS NULL)
  AND COALESCE("measured_duration_seconds", 0) >= 0
);
