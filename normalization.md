# Normalization Analysis for ALX Airbnb Database

## ✅ First Normal Form (1NF)

**Definition**: All columns must contain only atomic values (no repeating groups or arrays).

**✅ Satisfied**:
- All entities (`USER`, `PROPERTY`, `BOOKING`, `MESSAGE`, `REVIEW`, `PAYMENT`) contain atomic attributes only.
- No multi-valued fields or arrays exist.
- Example: `message_body`, `comment`, and `description` are atomic text fields.

---

## ✅ Second Normal Form (2NF)

**Definition**: Entity is in 1NF and all non-key attributes are fully functionally dependent on the entire primary key.

**Check**:
- Composite primary keys like `MESSAGE(message_id, sender_id, recipient_id)` and `REVIEW(review_id, property_id, user_id)` are used correctly.
- All non-key fields (like `message_body`, `sent_at`, `comment`, `rating`) depend on the whole composite key — not just a part.

**✅ Satisfied**:
- No partial dependencies observed in any entity.
- Surrogate keys (`ID`) are used properly alongside logical PKs for clarity.

---

## ✅ Third Normal Form (3NF)

**Definition**: Entity is in 2NF and has no transitive dependencies (i.e., non-key fields do not depend on other non-key fields).

**Checks**:
- `USER` table: all fields depend on `user_id`. No transitive dependency.
- `PROPERTY` links to `USER`, `REVIEW`, etc., via foreign keys — no derived or redundant data present.
- `BOOKING` has direct FKs to `USER`, `PROPERTY`, and `PAYMENT` — no calculated fields like `days_booked` or `user_email` that violate 3NF.
- `PAYMENT` correctly stores amount and method but not any user-related info that could be transitive.

**✅ Satisfied**:
- Every table is free from transitive dependencies.
- Referential integrity is ensured via foreign keys.

---

## ✅ Summary

The current database schema is **fully normalized up to 3NF**:

| Normal Form | Status     |
|-------------|------------|
| 1NF         | ✅ Satisfied |
| 2NF         | ✅ Satisfied |
| 3NF         | ✅ Satisfied |

All relationships and dependencies are correctly modeled using foreign keys, and no redundant or transitive fields exist. The schema is optimized for integrity, maintainability, and scalability.

