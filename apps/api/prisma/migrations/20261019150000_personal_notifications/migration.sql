-- Thông báo VXN Plus của hành khách không gắn một nhà xe cụ thể.
ALTER TABLE notifications ALTER COLUMN operator_id DROP NOT NULL;
ALTER TABLE notification_deliveries ALTER COLUMN operator_id DROP NOT NULL;
ALTER TABLE notification_deliveries ADD CONSTRAINT notification_deliveries_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES notifications(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE notification_deliveries ADD CONSTRAINT personal_notification_recipient_required CHECK (operator_id IS NOT NULL OR (recipient_type IS NOT NULL AND recipient_id IS NOT NULL));
