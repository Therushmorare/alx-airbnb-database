-- Enable UUID support (PostgreSQL specific)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================
-- USERS TABLE
-- ========================
CREATE TABLE users (
    user_id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name      VARCHAR NOT NULL,
    last_name       VARCHAR NOT NULL,
    email           VARCHAR UNIQUE NOT NULL,
    password_hash   VARCHAR NOT NULL,
    phone_number    VARCHAR,
    role            VARCHAR NOT NULL CHECK (role IN ('guest', 'host', 'admin')),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);

-- ========================
-- PROPERTIES TABLE
-- ========================
CREATE TABLE properties (
    property_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id         UUID NOT NULL,
    name            VARCHAR NOT NULL,
    description     TEXT NOT NULL,
    location        VARCHAR NOT NULL,
    price_per_night DECIMAL NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES users(user_id)
);

CREATE INDEX idx_properties_property_id ON properties(property_id);

-- ========================
-- BOOKINGS TABLE
-- ========================
CREATE TABLE bookings (
    booking_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id     UUID NOT NULL,
    user_id         UUID NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    total_price     DECIMAL NOT NULL,
    status          VARCHAR NOT NULL CHECK (status IN ('pending', 'confirmed', 'canceled')),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES properties(property_id),
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX idx_bookings_booking_id ON bookings(booking_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- ========================
-- PAYMENTS TABLE
-- ========================
CREATE TABLE payments (
    payment_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id      UUID NOT NULL UNIQUE,
    amount          DECIMAL NOT NULL,
    payment_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method  VARCHAR NOT NULL CHECK (payment_method IN ('credit_card', 'paypal', 'stripe')),

    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

CREATE INDEX idx_payments_booking_id ON payments(booking_id);

-- ========================
-- REVIEWS TABLE
-- ========================
CREATE TABLE reviews (
    review_id       UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id     UUID NOT NULL,
    user_id         UUID NOT NULL,
    rating          INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES properties(property_id),
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- ========================
-- MESSAGES TABLE
-- ========================
CREATE TABLE messages (
    message_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id       UUID NOT NULL,
    recipient_id    UUID NOT NULL,
    message_body    TEXT NOT NULL,
    sent_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES users(user_id),
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES users(user_id)
);

CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON messages(recipient_id);
