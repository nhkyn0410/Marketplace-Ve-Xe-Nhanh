-- Chỉ Platform được xác nhận đã thu phí; tenant chỉ đọc, không tự xóa công nợ bằng khoản thu giả.
DROP POLICY "tenant_isolation" ON "counter_commission_settlements";
CREATE POLICY "tenant_read" ON "counter_commission_settlements" FOR SELECT USING (app_rls_allows("operator_id"));
CREATE POLICY "platform_collect" ON "counter_commission_settlements" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
