ALTER TYPE "NotificationKind" ADD VALUE 'OPERATIONS_ALERT';
ALTER TYPE "NotificationKind" ADD VALUE 'LOYALTY_UPDATED';
ALTER TYPE "NotificationKind" ADD VALUE 'PROMOTION';
ALTER TABLE notification_deliveries ADD COLUMN recipient_type "SubjectType", ADD COLUMN recipient_id text;
ALTER TABLE notifications ADD COLUMN channels_prepared_at timestamptz;
CREATE INDEX notifications_unprepared_idx ON notifications(created_at) WHERE channels_prepared_at IS NULL;
CREATE INDEX notification_deliveries_recipient_idx ON notification_deliveries(recipient_type, recipient_id, created_at DESC);
CREATE TABLE notification_preferences (
 id text PRIMARY KEY, subject_type "SubjectType" NOT NULL, subject_id text NOT NULL, operator_id text REFERENCES operator_profiles(id),
 kind "NotificationKind" NOT NULL, email boolean NOT NULL DEFAULT true, push boolean NOT NULL DEFAULT true, updated_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(subject_type,subject_id,kind),
 CHECK (subject_type NOT IN ('OPERATOR','EMPLOYEE') OR operator_id IS NOT NULL)
);
CREATE TABLE push_devices (
 id text PRIMARY KEY, subject_type "SubjectType" NOT NULL, subject_id text NOT NULL, operator_id text REFERENCES operator_profiles(id),
 provider text NOT NULL CHECK(provider IN ('FCM','APNS')), token text NOT NULL, token_hash text NOT NULL UNIQUE,
 active boolean NOT NULL DEFAULT true, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(),
 CHECK (subject_type NOT IN ('OPERATOR','EMPLOYEE') OR operator_id IS NOT NULL)
);
CREATE INDEX push_devices_subject_idx ON push_devices(subject_type,subject_id,active);
CREATE TABLE notification_push_receipts (
 id text PRIMARY KEY, delivery_id text NOT NULL REFERENCES notification_deliveries(id), device_id text NOT NULL REFERENCES push_devices(id),
 status "NotificationDeliveryStatus" NOT NULL DEFAULT 'PENDING', updated_at timestamptz NOT NULL DEFAULT now(), UNIQUE(delivery_id,device_id)
);
ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_preferences FORCE ROW LEVEL SECURITY;
CREATE POLICY notification_preferences_scope ON notification_preferences USING (app_rls_allows(operator_id)) WITH CHECK (app_rls_allows(operator_id));
ALTER TABLE push_devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE push_devices FORCE ROW LEVEL SECURITY;
CREATE POLICY push_devices_scope ON push_devices USING (app_rls_allows(operator_id)) WITH CHECK (app_rls_allows(operator_id));
ALTER TABLE notification_push_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_push_receipts FORCE ROW LEVEL SECURITY;
CREATE POLICY notification_push_receipts_scope ON notification_push_receipts USING (EXISTS (SELECT 1 FROM notification_deliveries d WHERE d.id=delivery_id)) WITH CHECK (EXISTS (SELECT 1 FROM notification_deliveries d WHERE d.id=delivery_id));
