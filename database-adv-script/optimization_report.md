EXPLAIN ANALYZE
SELECT 
    b.booking_id, b.booking_date,
    u.user_id, u.username, u.email,
    p.property_id, p.name, p.location,
    pay.payment_id, pay.amount, pay.payment_date, pay.status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id;

Common Issues in the Plan Without Indexes:

    Sequential scans on large tables like bookings and payments

    Nested loop joins when joining large unindexed tables

    Unnecessary columns being selected from joined tables (if not needed)

-- Speed up JOINs
  CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
  CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
  CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);
  
-- Optimized query: only fetch necessary fields, and limit result
SELECT 
    b.booking_id,
    b.booking_date,
    u.username,
    p.name AS property_name,
    pay.amount,
    pay.status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id
ORDER BY b.booking_date DESC
LIMIT 50;
