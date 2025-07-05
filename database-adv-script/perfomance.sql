
-- Retrieve all bookings with user, property, and payment details
SELECT
  b.booking_id,
  b.booking_date,
  u.user_id,
  u.username,
  u.email,
  p.property_id,
  p.name AS property_name,
  p.location,
  pay.payment_id,
  pay.amount,
  pay.payment_date,
  pay.status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id;
