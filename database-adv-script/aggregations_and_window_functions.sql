---Write a query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.

SELECT u.id, u.name, COUNT(b.id) AS total_bookings
FROM Users u
LEFT JOIN Bookings b ON b.user_id = u.id
GROUP BY u.id, u.name;

---Use a window function (ROW_NUMBER, RANK) to rank properties based on the total number of bookings they have received.
WITH property_bookings AS (
  SELECT
    p.id,
    p.name,
    COUNT(b.id) AS total_bookings
  FROM Properties p
  LEFT JOIN Bookings b ON b.property_id = p.id
  GROUP BY p.id, p.name
),
ranked_properties AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS rank
  FROM property_bookings
)
SELECT *
FROM ranked_properties
WHERE rank = 1;
