ALTER TABLE users ADD COLUMN phone TEXT, ADD COLUMN date_of_birth DATE;

-- Dữ liệu thuộc tài khoản hành khách, không thuộc tenant nhà xe (DB-PRIN-01).
CREATE TABLE saved_passengers (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL CHECK (length(full_name) BETWEEN 1 AND 100),
  phone TEXT,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(3) NOT NULL,
  CONSTRAINT saved_passenger_phone CHECK (phone IS NULL OR phone ~ '^(0|\+84)[0-9]{9}$')
);
CREATE INDEX saved_passengers_user_id_created_at_idx ON saved_passengers(user_id, created_at);
ALTER TABLE users ADD CONSTRAINT user_profile_phone CHECK (phone IS NULL OR phone ~ '^(0|\+84)[0-9]{9}$');
