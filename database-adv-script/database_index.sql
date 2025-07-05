-- Indexes on Users
CREATE INDEX IF NOT EXISTS idx_users_email ON Users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON Users(username);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON Users(is_active);

-- Indexes on Bookings
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON Bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_date ON Bookings(booking_date);

-- Composite index for queries filtering by user and property (if applicable)
CREATE INDEX IF NOT EXISTS idx_bookings_user_property ON Bookings(user_id, property_id);

-- Indexes on Properties
CREATE INDEX IF NOT EXISTS idx_properties_location ON Properties(location);
CREATE INDEX IF NOT EXISTS idx_properties_price ON Properties(price);
CREATE INDEX IF NOT EXISTS idx_properties_status ON Properties(status);

EXPLAIN ANALYZE
SELECT b.*
FROM Bookings b
JOIN Users u ON b.user_id = u.id
WHERE u.is_active = true
ORDER BY b.booking_date DESC
LIMIT 50;
