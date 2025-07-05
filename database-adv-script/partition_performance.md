Partitioning Strategy

partitioning the bookings table by start_date using monthly range partitions. This allowed the database to automatically prune irrelevant partitions during queries, reducing scan time and improving I/O efficiency.
