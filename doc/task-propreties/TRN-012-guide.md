# TASK-TRN-012 — Guide kiểm chứng: Thiết kế lại điểm dừng (backend nhà xe)

> Mục tiêu: chứng minh điểm riêng chỉ còn văn phòng / trạm dừng nghỉ, nhà xe không vượt được khóa của Admin, đề xuất phải kèm căn cứ công bố, tuyến lưu đúng quyền đón / trả, và ô tìm gõ không dấu vẫn ra kết quả.
> Phạm vi / giả định: `TRN-012-todo.md`. Checklist nghiệm thu: `TRN-012-verification-checklist.md`.

## 0. Gate trước khi chạy

- [ ] `pnpm install` xong; đang ở nhánh `TASK-TRN-012`.
- [ ] Postgres 16 + Redis 7 + Mongo 7 chạy ([RB-05](../runbook/RB-05-local-infra.md)).
- [ ] `DATABASE_URL` = role app; `MIGRATION_DATABASE_URL` = owner.

## 1. Migrate

```powershell
pnpm --filter @vexenhanh/api run prisma:migrate:deploy
pnpm --filter @vexenhanh/api run db:app-role
```

Hai migration mới, chạy theo thứ tự:

1. `20261005010000_add_stop_point_suspended_status` — thêm giá trị `SUSPENDED`. Tách riêng vì Postgres không cho dùng giá trị enum mới ngay trong transaction vừa thêm nó.
2. `20261005020000_redesign_stop_points` — dọn dữ liệu thử, thêm cột / ràng buộc / policy, cài extension `unaccent` và cột `search_text`.

**Migration thứ hai xóa dữ liệu** (Khanh chốt 05/10/2026): điểm riêng loại bến xe / điểm dừng đón trả, các tuyến đang dùng chúng, tuyến bắt đầu hoặc kết thúc ở trạm dừng nghỉ, và đề xuất loại văn phòng / trạm dừng nghỉ. Muốn biết trước sẽ mất gì, chạy bằng owner **trước khi** migrate:

```sql
SELECT 'điểm riêng' AS loai, count(*) FROM stop_points WHERE type IN ('BUS_STATION', 'PICKUP_POINT')
UNION ALL
SELECT 'đề xuất', count(*) FROM stop_point_proposals WHERE type IN ('OFFICE', 'REST_STOP')
UNION ALL
SELECT 'tuyến', count(DISTINCT rs.route_id)
  FROM route_stops rs
  LEFT JOIN stop_points own ON own.id = rs.stop_point_id
  LEFT JOIN stop_points_catalog shared ON shared.id = rs.catalog_stop_point_id
 WHERE own.type IN ('BUS_STATION', 'PICKUP_POINT')
    OR (rs.role IN ('ORIGIN', 'DESTINATION') AND COALESCE(own.type, shared.type) = 'REST_STOP');
```

Kiểm sau khi migrate (bằng owner):

```sql
SELECT DISTINCT type FROM stop_points;                       -- chỉ OFFICE, REST_STOP
SELECT DISTINCT type FROM stop_point_proposals;              -- chỉ BUS_STATION, PICKUP_POINT
SELECT polname, polcmd FROM pg_policy WHERE polrelid = 'stop_points'::regclass ORDER BY polname;
SELECT name, search_text FROM stop_points_catalog LIMIT 5;   -- search_text là chữ thường, không dấu
```

## 2. Test

```powershell
$env:REQUIRE_DB_TESTS = "1"
pnpm --filter @vexenhanh/api test
pnpm --filter @vexenhanh/api run typecheck
pnpm --filter @vexenhanh/api run lint
```

Không chấp nhận test tích hợp bị skip. Phần của task nằm ở `src/route/route.int.spec.ts` (database thật, role app), `route-dto.spec.ts`, `route.http.spec.ts`, `src/catalog/*.spec.ts`, `src/common/search-text.spec.ts`.

## 3. Smoke HTTP

Với token Owner đã qua MFA (`$h = @{ Authorization = "Bearer <OWNER_ACCESS_TOKEN>" }`, `$api = "http://localhost:3001/v1"`), lấy sẵn `$provinceId`, `$wardId` từ `/catalog/provinces`, `/catalog/wards`:

```powershell
$point = @{ name = "Văn phòng Đà Lạt"; type = "OFFICE"; address = "12 Trần Phú"; provinceId = $provinceId; wardId = $wardId; latitude = 11.94; longitude = 108.44; description = $null; status = "ACTIVE" }
$body = { param($p) $p | ConvertTo-Json }
Invoke-RestMethod -Method Post "$api/operator/stop-points" -Headers $h -ContentType "application/json" -Body (& $body $point)
```

Kỳ vọng:

| Thao tác | Kết quả |
| --- | --- |
| Tạo với `type = "OFFICE"` | 201, có `suspensionReason = null`, `routeCount = 0` |
| Tạo với `type = "BUS_STATION"` | 422 `STOP_POINT_TYPE_NOT_ALLOWED` |
| Tạo / sửa với `status = "SUSPENDED"` | 400 |
| `GET /operator/stop-points?q=van phong da lat` | ra điểm vừa tạo |
| `GET /catalog/stop-points?q=ben xe` | ra các bến có chữ "Bến xe" |
| Gửi đề xuất thiếu `legalBasis`, hoặc `type = "OFFICE"` | 400 |
| Tạo tuyến thiếu `allowPickup` / `allowDropoff` | 400 |
| Tạo tuyến có điểm đầu `allowDropoff = true` | 422 `ROUTE_STOP_PICKUP_DROPOFF_INVALID` |

Thử khóa (chưa có API Admin — `TASK-ADM-004`), chạy bằng owner cả khối trong một lần:

```sql
BEGIN;
SELECT set_config('app.scope', 'platform', true);
UPDATE stop_points SET status = 'SUSPENDED', suspension_reason = 'Sai vị trí' WHERE id = '<id>';
COMMIT;
```

Sau đó `PUT /operator/stop-points/<id>` → 409 `STOP_POINT_SUSPENDED`; `GET` trả `status = "SUSPENDED"` kèm lý do. Mở lại: cùng khối trên với `status = 'ACTIVE', suspension_reason = NULL`.

## 4. OpenAPI và client

Theo [RB-04](../runbook/RB-04-api-client.md). `git diff` chỉ đổi phần điểm dừng, đề xuất, tuyến và catalog điểm dừng.

Lưu ý trên Windows: sau khi sinh client Dart, `git status` có thể liệt kê thêm nhiều file không đổi nội dung (chỉ khác kiểu xuống dòng). `git diff` của các file đó rỗng; chúng tự biến mất khi `git add`.

## 5. Production rollout

Backup → chạy câu đếm ở §1 để biết sẽ mất gì → `prisma:migrate:deploy` bằng owner → `db:app-role` → deploy API → smoke §3. Không cần seed lại catalog.

- **Extension `unaccent`:** migration tự cài (`CREATE EXTENSION IF NOT EXISTS`). Trên Supabase / Neon chủ database cài được. Nếu môi trường không cho, bật extension `unaccent` trong trang quản trị rồi chạy lại migration.
- **Migration dừng vì khóa ngoại:** tuyến cần xóa đang được bảng khác trỏ tới (chuyến). Migration chưa đổi gì. Xử lý dữ liệu đó trước (hỏi lại nếu là dữ liệu thật), rồi:
  ```powershell
  pnpm --filter @vexenhanh/api exec prisma migrate resolve --rolled-back 20261005020000_redesign_stop_points
  pnpm --filter @vexenhanh/api run prisma:migrate:deploy
  ```
- **Tìm `q` báo lỗi quyền trên hàm `vxn_search_text`:** database đã thu hồi quyền chạy hàm mặc định. Cấp lại bằng owner: `GRANT EXECUTE ON FUNCTION vxn_search_text(TEXT) TO vexenhanh_app;`

## Lưu ý phạm vi

- Không tick checklist nếu chưa có evidence.
- Không tự promote tài liệu SDLC sang Approved.
- Test mock không phải bằng chứng cho CHECK / RLS / cột sinh; các mục đó phải chạy Postgres thật bằng role app.
