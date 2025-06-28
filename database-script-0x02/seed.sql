-- USERS
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  (uuid_generate_v4(), 'Alice', 'Smith', 'alice@example.com', 'hashed_pw_1', '1234567890', 'guest'),
  (uuid_generate_v4(), 'Bob', 'Johnson', 'bob@example.com', 'hashed_pw_2', '0987654321', 'host'),
  (uuid_generate_v4(), 'Clara', 'Nguyen', 'clara@example.com', 'hashed_pw_3', '0812345678', 'admin');

-- PROPERTIES
INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
SELECT uuid_generate_v4(), u.user_id, 'Ocean View Apartment', 'Beautiful sea-facing apartment.', 'Cape Town', 1200.00
FROM users u WHERE u.email = 'bob@example.com'
UNION ALL
SELECT uuid_generate_v4(), u.user_id, 'City Loft', 'Modern apartment in city center.', 'Johannesburg', 950.00
FROM users u WHERE u.email = 'bob@example.com';

-- BOOKINGS
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
SELECT uuid_generate_v4(), p.property_id, u.user_id, '2025-07-01', '2025-07-05', 4800.00, 'confirmed'
FROM users u, properties p
WHERE u.email = 'alice@example.com' AND p.name = 'Ocean View Apartment'
UNION ALL
SELECT uuid_generate_v4(), p.property_id, u.user_id, '2025-08-10', '2025-08-12', 1900.00, 'pending'
FROM users u, properties p
WHERE u.email = 'alice@example.com' AND p.name = 'City Loft';

-- PAYMENTS
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
SELECT uuid_generate_v4(), b.booking_id, b.total_price, 'credit_card'
FROM bookings b
WHERE b.status = 'confirmed';

-- REVIEWS
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
SELECT uuid_generate_v4(), p.property_id, u.user_id, 5, 'Absolutely loved the place!'
FROM users u, properties p
WHERE u.email = 'alice@example.com' AND p.name = 'Ocean View Apartment';

-- MESSAGES
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
SELECT uuid_generate_v4(), s.user_id, r.user_id, 'Hi! Is the property available in September?'
FROM users s, users r
WHERE s.email = 'alice@example.com' AND r.email = 'bob@example.com'
UNION ALL
SELECT uuid_generate_v4(), r.user_id, s.user_id, 'Yes, it is available!'
FROM users s, users r
WHERE s.email = 'alice@example.com' AND r.email = 'bob@example.com';
