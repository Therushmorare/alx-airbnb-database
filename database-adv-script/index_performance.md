# Index Performance Benchmark: User, Booking, and Property Tables

## Objective

To improve SQL query performance by identifying high-usage columns in the `Users`, `Bookings`, and `Properties` tables and creating appropriate indexes. We then benchmarked query execution time **before and after** indexing using `EXPLAIN ANALYZE`.

---

## Tables Overview

We worked with the following tables:

- **Users**: ~10 records
- **Properties**: ~10 records
- **Bookings**: ~100 records

---

## Identified High-Usage Columns

| Table      | Column(s)                   | Usage                                 |
|------------|-----------------------------|----------------------------------------|
| `Users`    | `email`, `username`         | Lookups, authentication                |
| `Users`    | `is_active`                 | Frequently filtered (`WHERE`)         |
| `Bookings` | `user_id`, `property_id`    | Foreign key JOINs                      |
| `Bookings` | `booking_date`              | Date-based filtering or ordering       |
| `Properties` | `location`, `price`, `status` | Search filters, display ordering   |

---

## Benchmark query used
  SELECT b.*
  FROM Bookings b
  JOIN Users u ON b.user_id = u.id
  WHERE u.is_active = true
  ORDER BY b.booking_date DESC
  LIMIT 50;


## Before Indexing
  Seq Scan on Users u
    Filter: is_active = true
  
  Nested Loop
    Join Filter: b.user_id = u.id
    -> Seq Scan on Bookings b
  
  Sort: booking_date DESC
  Execution Time: ~430 ms

# After Indexing
  Index Scan using idx_users_is_active on Users u
    Index Cond: is_active = true
  
  Hash Join
    Join Cond: b.user_id = u.id
  
  Index Scan using idx_bookings_booking_date on Bookings b
    Order By: booking_date DESC
  Execution Time: ~60–80 ms
  
## Indexes Created

```sql
-- Users table
CREATE INDEX IF NOT EXISTS idx_users_email ON Users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON Users(username);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON Users(is_active);

-- Bookings table
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON Bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_date ON Bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_bookings_user_property ON Bookings(user_id, property_id);

-- Properties table
CREATE INDEX IF NOT EXISTS idx_properties_location ON Properties(location);
CREATE INDEX IF NOT EXISTS idx_properties_price ON Properties(price);
CREATE INDEX IF NOT EXISTS idx_properties_status ON Properties(status);---
