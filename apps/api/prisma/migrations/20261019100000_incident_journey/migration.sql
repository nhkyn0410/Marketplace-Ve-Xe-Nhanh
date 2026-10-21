-- UC-22, FR-EMP-10/11: sự cố, nhật trình và cửa sổ đón riêng theo điểm.
ALTER TABLE trip_stops ADD COLUMN pickup_window_start TIMESTAMP(3), ADD COLUMN pickup_window_end TIMESTAMP(3);
ALTER TABLE trip_stops ADD CONSTRAINT trip_stops_pickup_window_check CHECK (
  (pickup_window_start IS NULL AND pickup_window_end IS NULL) OR
  (allow_pickup AND pickup_window_start IS NOT NULL AND pickup_window_end IS NOT NULL AND pickup_window_start <= pickup_window_end)
);

CREATE TABLE incident_reports (
  id TEXT PRIMARY KEY, operator_id TEXT NOT NULL, trip_id TEXT NOT NULL, employee_id TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('VEHICLE','TRAFFIC','PASSENGER','SAFETY','OTHER')),
  severity TEXT NOT NULL CHECK (severity IN ('LOW','MEDIUM','HIGH','CRITICAL')),
  description TEXT NOT NULL CHECK (length(description) BETWEEN 1 AND 3000), location TEXT,
  occurred_at TIMESTAMP(3) NOT NULL, evidence JSONB NOT NULL DEFAULT '[]',
  resolved_at TIMESTAMP(3), resolved_by TEXT, resolution TEXT,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (trip_id, operator_id) REFERENCES trips(id, operator_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (employee_id, operator_id) REFERENCES employee_accounts(id, operator_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT incident_resolution_check CHECK ((resolved_at IS NULL AND resolved_by IS NULL AND resolution IS NULL) OR (resolved_at IS NOT NULL AND resolved_by IS NOT NULL AND resolution IS NOT NULL))
);
CREATE INDEX incident_reports_operator_id_created_at_idx ON incident_reports(operator_id, created_at);
CREATE INDEX incident_reports_operator_id_trip_id_idx ON incident_reports(operator_id, trip_id);

CREATE TABLE journey_logs (
  id TEXT PRIMARY KEY, operator_id TEXT NOT NULL, trip_id TEXT NOT NULL, employee_id TEXT NOT NULL,
  stop_sequence INTEGER, actual_at TIMESTAMP(3) NOT NULL, vehicle_status TEXT, note TEXT,
  delay_minutes INTEGER NOT NULL DEFAULT 0, created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (trip_id, operator_id) REFERENCES trips(id, operator_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (employee_id, operator_id) REFERENCES employee_accounts(id, operator_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (trip_id, stop_sequence) REFERENCES trip_stops(trip_id, sequence) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT journey_log_content_check CHECK (stop_sequence IS NOT NULL OR vehicle_status IS NOT NULL OR note IS NOT NULL)
);
CREATE INDEX journey_logs_operator_id_trip_id_actual_at_idx ON journey_logs(operator_id, trip_id, actual_at);

ALTER TABLE incident_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE incident_reports FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON incident_reports USING (
  current_setting('app.scope', true) IN ('platform','system') OR
  (current_setting('app.scope', true) = 'tenant' AND operator_id = current_setting('app.operator_id', true))
) WITH CHECK (
  current_setting('app.scope', true) IN ('platform','system') OR
  (current_setting('app.scope', true) = 'tenant' AND operator_id = current_setting('app.operator_id', true))
);
ALTER TABLE journey_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE journey_logs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON journey_logs USING (
  current_setting('app.scope', true) IN ('platform','system') OR
  (current_setting('app.scope', true) = 'tenant' AND operator_id = current_setting('app.operator_id', true))
) WITH CHECK (
  current_setting('app.scope', true) IN ('platform','system') OR
  (current_setting('app.scope', true) = 'tenant' AND operator_id = current_setting('app.operator_id', true))
);
