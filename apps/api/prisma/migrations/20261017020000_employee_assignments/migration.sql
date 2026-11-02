-- TASK-EMP-001 (phía Operator OS) — phân công nhân viên cho chuyến (UC-16 bước 4–6, FR-OPS: "gán nhân viên (Employee có
-- role DRIVER)"; Figma "05 · Nhân viên / Phân công chuyến"). Thiết kế AI tự đề xuất, chờ Khanh duyệt
-- (`doc/task-propreties/EMP-001-todo.md`). v1 chỉ phân công tài xế: mỗi chuyến tối đa một người mỗi vai trò.
-- Chống một tài xế chạy hai chuyến chồng giờ: service khoá dòng nhân viên rồi kiểm (giờ chuyến sửa được nên không
-- chép giờ vào bảng này để dùng EXCLUDE).

-- CreateIndex — cho FK ghép (nhân viên phải thuộc đúng tenant của phân công).
CREATE UNIQUE INDEX "employee_accounts_id_operator_id_key" ON "employee_accounts"("id", "operator_id");

-- CreateTable
CREATE TABLE "employee_assignments" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "trip_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "role" "EmployeeRole" NOT NULL,
    "assigned_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "employee_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateIndex — mỗi chuyến tối đa một người mỗi vai trò.
CREATE UNIQUE INDEX "employee_assignments_trip_id_role_key" ON "employee_assignments"("trip_id", "role");

-- CreateIndex
CREATE INDEX "employee_assignments_employee_id_idx" ON "employee_assignments"("employee_id");

-- AddForeignKey
ALTER TABLE "employee_assignments" ADD CONSTRAINT "employee_assignments_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey — chuyến / nhân viên phải thuộc đúng tenant của phân công.
ALTER TABLE "employee_assignments" ADD CONSTRAINT "employee_assignments_trip_id_operator_id_fkey" FOREIGN KEY ("trip_id", "operator_id") REFERENCES "trips"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "employee_assignments" ADD CONSTRAINT "employee_assignments_employee_id_operator_id_fkey" FOREIGN KEY ("employee_id", "operator_id") REFERENCES "employee_accounts"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- RLS
ALTER TABLE "employee_assignments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "employee_assignments" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "employee_assignments"
  USING (app_rls_allows("operator_id"))
  WITH CHECK (app_rls_allows("operator_id"));
