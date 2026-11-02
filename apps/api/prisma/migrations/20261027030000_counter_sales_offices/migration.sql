-- COUNTER-SALES: nhiều văn phòng và phân công tài khoản, cùng tenant với nhà xe.
ALTER TYPE "EmployeeRole" ADD VALUE 'SALES_STAFF';

CREATE TABLE "sales_offices" (
  "id" TEXT NOT NULL,
  "operator_id" TEXT NOT NULL,
  "code" TEXT NOT NULL,
  "name" TEXT NOT NULL,
  "address" TEXT NOT NULL,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "version" INTEGER NOT NULL DEFAULT 0,
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "sales_offices_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "sales_offices_code_format" CHECK ("code" ~ '^[A-Z0-9][A-Z0-9_-]{1,29}$'),
  CONSTRAINT "sales_offices_name_length" CHECK (char_length(btrim("name")) BETWEEN 1 AND 100),
  CONSTRAINT "sales_offices_address_length" CHECK (char_length(btrim("address")) BETWEEN 1 AND 255),
  CONSTRAINT "sales_offices_version_nonnegative" CHECK ("version" >= 0)
);
CREATE UNIQUE INDEX "sales_offices_id_operator_id_key" ON "sales_offices"("id", "operator_id");
CREATE UNIQUE INDEX "sales_offices_operator_id_code_key" ON "sales_offices"("operator_id", "code");
CREATE INDEX "sales_offices_operator_id_active_idx" ON "sales_offices"("operator_id", "active");
ALTER TABLE "sales_offices" ADD CONSTRAINT "sales_offices_operator_id_fkey"
  FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

CREATE TABLE "sales_office_assignments" (
  "office_id" TEXT NOT NULL,
  "employee_id" TEXT NOT NULL,
  "operator_id" TEXT NOT NULL,
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "sales_office_assignments_pkey" PRIMARY KEY ("office_id", "employee_id")
);
CREATE INDEX "sales_office_assignments_operator_id_employee_id_idx" ON "sales_office_assignments"("operator_id", "employee_id");
ALTER TABLE "sales_office_assignments" ADD CONSTRAINT "sales_office_assignments_office_id_operator_id_fkey"
  FOREIGN KEY ("office_id", "operator_id") REFERENCES "sales_offices"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "sales_office_assignments" ADD CONSTRAINT "sales_office_assignments_employee_id_operator_id_fkey"
  FOREIGN KEY ("employee_id", "operator_id") REFERENCES "employee_accounts"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE "sales_offices" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "sales_offices" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "sales_offices"
  USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "sales_office_assignments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "sales_office_assignments" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "sales_office_assignments"
  USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
