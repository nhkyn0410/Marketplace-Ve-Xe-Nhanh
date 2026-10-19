-- DB-MIG-07 (TASK-LOY-001): phiên bản đầu tham số VXN Plus. Khanh 18/10/2026 (LLD-OQ-06): số liệu Figma — 1 điểm = 1.000 ₫ khi đổi,
-- đổi tối thiểu 100 điểm, voucher dùng 30 ngày, hạng Đồng / Bạc / Vàng / Bạch kim từ 0 / 2.000 / 5.000 / 10.000 điểm tích 12 tháng với
-- hệ số 1,0 / 1,2 / 1,5 / 2,0 — và tỷ lệ tích 1 điểm cho mỗi 10.000 ₫ khách thực trả. Hạn điểm 12 tháng: AI đề xuất (Figma chưa có số),
-- chờ Khanh duyệt. Admin sửa bằng phiên bản mới.
INSERT INTO "policy_versions" ("id", "type", "version", "status", "rules", "description", "change_reason", "effective_from", "published_at", "updated_at")
VALUES (
  gen_random_uuid()::text, 'LOYALTY', 1, 'PUBLISHED',
  '{"earnUnit": 10000, "pointValue": 1000, "minRedeemPoints": 100, "pointExpiryMonths": 12, "voucherValidityDays": 30, "tiers": [{"tier": "BRONZE", "minPoints": 0, "multiplierPercent": 100}, {"tier": "SILVER", "minPoints": 2000, "multiplierPercent": 120}, {"tier": "GOLD", "minPoints": 5000, "multiplierPercent": 150}, {"tier": "PLATINUM", "minPoints": 10000, "multiplierPercent": 200}]}',
  'Giá trị nền v1 (LLD-OQ-06, Khanh 18/10/2026).', 'Khởi tạo', '2026-10-18T17:00:00Z', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
