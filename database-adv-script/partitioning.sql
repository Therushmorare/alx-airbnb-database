-- Drop old tables if they exist
DROP TABLE IF EXISTS bookings CASCADE;

-- Create the parent table with PARTITION BY RANGE
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    booking_date TIMESTAMP DEFAULT NOW()
) PARTITION BY RANGE (start_date);

-- Create monthly partitions (example: Jan–Mar 2024)
CREATE TABLE bookings_2024_01 PARTITION OF bookings
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE bookings_2024_02 PARTITION OF bookings
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE bookings_2024_03 PARTITION OF bookings
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

-- Add indexes on each partition (local indexes)
CREATE INDEX ON bookings_2024_01 (user_id);
CREATE INDEX ON bookings_2024_01 (start_date);
CREATE INDEX ON bookings_2024_02 (user_id);
CREATE INDEX ON bookings_2024_02 (start_date);
CREATE INDEX ON bookings_2024_03 (user_id);
CREATE INDEX ON bookings_2024_03 (start_date);

-- SELECT query using WHERE clause on the partition key
EXPLAIN ANALYZE
SELECT * 
FROM bookings
WHERE start_date BETWEEN '2024-02-01' AND '2024-02-15';
