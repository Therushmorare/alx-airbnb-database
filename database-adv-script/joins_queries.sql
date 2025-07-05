-- Get all bookings along with the users who made them
SELECT 
    u.user_id,                     -- Unique ID of the user
    u.first_name,                  -- First name of the user
    u.last_name,                   -- Last name of the user
    u.email,                       -- Email of the user
    b.booking_id,                  -- Booking ID
    b.start_date,                  -- Start of the booking
    b.end_date,                    -- End of the booking
    b.status,                      -- Booking status (pending/confirmed/canceled)
    b.total_price                  -- Total price paid for the booking
FROM users u
INNER JOIN bookings b 
    ON u.user_id = b.user_id;      -- Match bookings to users who made them

-- List all properties, along with any reviews they may have
-- This includes properties that don't have reviews (LEFT JOIN)
SELECT 
    p.property_id,                 -- Unique ID of the property
    p.name AS property_name,       -- Property name
    p.location,                    -- Property location
    r.review_id,                   -- Review ID (if exists)
    r.rating,                      -- Star rating from the guest
    r.comment,                     -- Text of the review
    r.created_at                   -- Date when the review was created
FROM properties p
LEFT JOIN reviews r 
    ON r.property_id = p.property_id; -- Join reviews by property ID

-- Retrieve all users and all bookings
-- Even if a user has no bookings or a booking has no matching user
SELECT 
    u.user_id,                     -- User ID (null if booking is orphaned)
    u.first_name,                  -- First name (if user exists)
    u.email,                       -- Email address (if user exists)
    b.booking_id,                  -- Booking ID (null if user never booked)
    b.start_date,                  -- Booking start date
    b.status                       -- Status of the booking
FROM bookings b
FULL OUTER JOIN users u 
    ON b.user_id = u.user_id;      -- Match users to bookings by user_id
