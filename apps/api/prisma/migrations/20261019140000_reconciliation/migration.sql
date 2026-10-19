CREATE TABLE reconciliation_records (
  id TEXT PRIMARY KEY,
  source TEXT NOT NULL CHECK (source IN ('MANUAL', 'SCHEDULED')),
  status TEXT NOT NULL DEFAULT 'QUEUED' CHECK (status IN ('QUEUED', 'RUNNING', 'COMPLETED', 'FAILED')),
  requested_by TEXT,
  reason TEXT,
  checkpoint TEXT NOT NULL DEFAULT 'QUEUED',
  payment_result JSONB,
  ledger_entries_checked INTEGER NOT NULL DEFAULT 0,
  payouts_checked INTEGER NOT NULL DEFAULT 0,
  issue_count INTEGER NOT NULL DEFAULT 0,
  issues JSONB NOT NULL DEFAULT '[]',
  error TEXT,
  started_at TIMESTAMP(3),
  finished_at TIMESTAMP(3),
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX reconciliation_records_created_at_idx ON reconciliation_records(created_at DESC);
ALTER TABLE reconciliation_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE reconciliation_records FORCE ROW LEVEL SECURITY;
CREATE POLICY platform_only ON reconciliation_records
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
