-- TASK-IAM-006 — tách cổng đăng nhập Employee khỏi Owner (ADR-017 amend 28/09/2026).
--
-- Owner (operator_accounts) và Employee (employee_accounts) vẫn chung registry
-- `operator_login_names`, nên username vẫn duy nhất trong một nhà xe. Login tách hai cổng theo
-- bảng; username Employee bắt buộc tiền tố `nv.` + chữ thường, Owner cấm tiền tố này.
--
-- Employee hiện có được đổi thành `nv.` + tên viết thường (`Driver01` → `nv.driver01`,
-- `nv.Tuan` → `nv.tuan`). Như PATCH username ở app, việc đổi tên tăng `auth_epoch` + `version`:
-- phiên cũ hết hiệu lực, nhân viên đăng nhập lại bằng username mới — cần báo họ tên mới.
-- Migration DỪNG (không đổi gì) nếu Owner đang dùng `nv.`, hoặc tên mới không hợp lệ/trùng nhau.

BEGIN;
SET LOCAL lock_timeout = '10s';

-- Migration DML must also work when the migration owner is subject to FORCE RLS.
SELECT set_config('app.scope', 'system', true);

-- Owner do Platform cấp tên đăng nhập; đổi ngầm là khóa họ ra ngoài → để người vận hành xử lý.
DO $$
DECLARE
  blocked TEXT;
BEGIN
  SELECT string_agg("id", ', ' ORDER BY "id")
    INTO blocked
    FROM "operator_accounts"
   WHERE lower("username") LIKE 'nv.%';
  IF blocked IS NOT NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '23514',
      MESSAGE = 'TASK-IAM-006 migration blocked: Owner username uses the Employee prefix nv.',
      DETAIL = 'operator_accounts.id: ' || blocked,
      HINT = 'Rename these Owner accounts, tell them the new login, then re-run the migration.';
  END IF;
END
$$;

CREATE TEMP TABLE "employee_username_rename" ON COMMIT DROP AS
SELECT "id",
       "operator_id",
       "username" AS "old_username",
       CASE
         WHEN lower("username") LIKE 'nv.%' THEN lower("username")
         ELSE 'nv.' || lower("username")
       END AS "new_username"
  FROM "employee_accounts";

DO $$
DECLARE
  blocked TEXT;
BEGIN
  -- Tên cũ dài 62–64 ký tự vượt 64 sau khi thêm tiền tố; tên có ký tự ngoài bộ cho phép cũng dừng.
  SELECT string_agg("id", ', ' ORDER BY "id")
    INTO blocked
    FROM "employee_username_rename"
   WHERE "new_username" !~ '^nv\.[a-z0-9._-]{2,61}$';
  IF blocked IS NOT NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '23514',
      MESSAGE = 'TASK-IAM-006 migration blocked: Employee username cannot become a valid nv. name',
      DETAIL = 'employee_accounts.id: ' || blocked,
      HINT = 'Rename these Employee accounts to at most 61 characters of [a-z0-9._-], then re-run.';
  END IF;

  -- Hạ chữ thường có thể gộp hai tên khác nhau (`Driver01` và `driver01`) trong cùng nhà xe.
  SELECT string_agg("id", ', ' ORDER BY "id")
    INTO blocked
    FROM "employee_username_rename" AS candidate
   WHERE EXISTS (
     SELECT 1
       FROM "employee_username_rename" AS other
      WHERE other."operator_id" = candidate."operator_id"
        AND other."new_username" = candidate."new_username"
        AND other."id" <> candidate."id"
   );
  IF blocked IS NOT NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '23505',
      MESSAGE = 'TASK-IAM-006 migration blocked: Employee usernames collide after adding nv. and lowercasing',
      DETAIL = 'employee_accounts.id: ' || blocked,
      HINT = 'Rename one account of each colliding pair inside the same operator, then re-run.';
  END IF;
END
$$;

-- Trigger `employee_accounts_reserve_login_name` dời reservation trong registry theo username mới.
UPDATE "employee_accounts" AS account
   SET "username" = renamed."new_username",
       "auth_epoch" = account."auth_epoch" + 1,
       "version" = account."version" + 1,
       "updated_at" = CURRENT_TIMESTAMP
  FROM "employee_username_rename" AS renamed
 WHERE account."id" = renamed."id"
   AND account."username" <> renamed."new_username";

-- FK account → registry là DEFERRABLE INITIALLY DEFERRED (IAM-005): kiểm ngay tại đây, vì ALTER TABLE
-- bên dưới bị Postgres từ chối khi bảng còn trigger event chờ tới lúc commit.
SET CONSTRAINTS ALL IMMEDIATE;

ALTER TABLE "employee_accounts" ADD CONSTRAINT "employee_accounts_username_employee_prefix"
  CHECK ("username" ~ '^nv\.[a-z0-9._-]{2,61}$');

ALTER TABLE "operator_accounts" ADD CONSTRAINT "operator_accounts_username_not_employee_prefix"
  CHECK (lower("username") NOT LIKE 'nv.%');

COMMIT;
