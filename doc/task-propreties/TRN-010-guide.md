# TASK-TRN-010 — Guide kiểm chứng: Phân loại xe và loại chỗ

> Mục tiêu: chứng minh catalog loại xe mang dạng chỗ + hạng xe, sơ đồ ghế nhận đủ 5 loại chỗ và tính đúng sức chứa, và migration không làm hỏng xe đang gắn loại `LIMOUSINE` cũ.
> Phạm vi / giả định: `TRN-010-todo.md`. Checklist nghiệm thu: `TRN-010-verification-checklist.md`.

## 0. Gate trước khi chạy

- [ ] `pnpm install` xong; đang ở nhánh `TASK-TRN-010`.
- [ ] Postgres 16 + Redis 7 + Mongo 7 chạy ([RB-05](../runbook/RB-05-local-infra.md)).
- [ ] `DATABASE_URL` = role app; `MIGRATION_DATABASE_URL` = owner.

## 1. Migrate rồi seed lại catalog

```powershell
pnpm --filter @vexenhanh/api run prisma:migrate:deploy
pnpm --filter @vexenhanh/api run db:app-role
pnpm --filter @vexenhanh/api run db:seed:catalog
```

Thứ tự bắt buộc: migrate trước, seed sau. Seed in `Tạo mới: … 2 loại xe` ở database đã có 4 loại cũ, hoặc `6 loại xe` ở database mới.

Kiểm bằng owner — phải ra đúng 6 dòng, không còn mã `LIMOUSINE`:

```sql
SELECT code, name, form, class FROM vehicle_types ORDER BY code;
```

## 2. Test

```powershell
$env:REQUIRE_DB_TESTS = "1"
pnpm --filter @vexenhanh/api test
pnpm --filter @vexenhanh/api run typecheck
pnpm --filter @vexenhanh/api run lint
```

Không chấp nhận test tích hợp bị skip.

## 3. Smoke HTTP

```powershell
$api = "http://localhost:3001/v1"
(Invoke-RestMethod "$api/catalog/vehicle-types").items | Format-Table code, form, class
```

Kỳ vọng: 6 dòng, mỗi dòng có `form` và `class`.

Với token Owner đã qua MFA (`$h = @{ Authorization = "Bearer <OWNER_ACCESS_TOKEN>" }`):

```powershell
$seatMap = @{
  name = "Hỗn hợp 2 tầng"
  layout = @{ decks = @(@{ deck = 1; rows = 2; columns = 2 }, @{ deck = 2; rows = 1; columns = 2 }) }
  seats = @(
    @{ code = "A1"; deck = 1; row = 1; column = 1; type = "SEAT" },
    @{ code = "A2"; deck = 1; row = 1; column = 2; type = "BED_DOUBLE" },
    @{ code = "B1"; deck = 2; row = 1; column = 1; type = "CABIN_DOUBLE" }
  )
} | ConvertTo-Json -Depth 5
$created = Invoke-RestMethod -Method Post "$api/operator/seat-maps" -Headers $h -ContentType "application/json" -Body $seatMap
$created | Select-Object seatCount, passengerCapacity, deckCount   # 3, 5, 2
```

Gửi `type = "SOFA"` → `400`, không ghi gì.

## 4. OpenAPI và client

Theo [RB-04](../runbook/RB-04-api-client.md). `git diff` chỉ đổi phần loại xe và sơ đồ ghế.

Lưu ý trên Windows: sau khi sinh client Dart, `git status` có thể liệt kê thêm nhiều file không đổi nội dung (chỉ khác kiểu xuống dòng). `git diff` của các file đó rỗng; chúng tự biến mất khi `git add`.

## 5. Production rollout

Backup → `prisma:migrate:deploy` bằng owner → `db:app-role` → `db:seed:catalog` (không `--with-samples`) → deploy API → smoke §3.

**Nếu migration dừng** với thông báo `TASK-TRN-010 migration blocked: vehicle_types has codes with no known form/class: <mã>`: database có loại xe ngoài 4 mã seed cũ. Migration chưa đổi gì. Cách xử lý:

1. Xem các dòng đó: `SELECT id, code, name FROM vehicle_types WHERE code NOT IN ('SEATER','SLEEPER','CABIN','LIMOUSINE');`
2. Nếu là dòng thử còn sót và không xe nào dùng thì xóa (chạy cả khối trong một lần):
   ```sql
   BEGIN;
   SELECT set_config('app.scope', 'system', true);
   DELETE FROM vehicle_types WHERE code = '<mã>';
   COMMIT;
   ```
   Nếu là loại xe thật thì hỏi lại trước khi xóa.
3. Đánh dấu lần chạy hỏng rồi chạy lại:
   ```powershell
   pnpm --filter @vexenhanh/api exec prisma migrate resolve --rolled-back 20261004010000_add_vehicle_classification
   pnpm --filter @vexenhanh/api run prisma:migrate:deploy
   ```

## Lưu ý phạm vi

- Không tick checklist nếu chưa có evidence.
- Không tự promote tài liệu SDLC sang Approved.
- Test mock không phải bằng chứng cho migration / enum / NOT NULL; các mục đó phải chạy Postgres thật.
