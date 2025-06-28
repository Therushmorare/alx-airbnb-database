CREATE TABLE user (
    id              SERIAL PRIMARY KEY,
    user_id         VARCHAR(50) UNIQUE NOT NULL,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(255) UNIQUE NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    phone_number    VARCHAR(20),
    role            VARCHAR(50),
    created_at      DATE DEFAULT CURRENT_DATE
);

CREATE TABLE property (
    id              SERIAL PRIMARY KEY,
    property_id     VARCHAR(50) UNIQUE NOT NULL,
    host_id         VARCHAR(50) NOT NULL,
    title           VARCHAR(255) NOT NULL,
    description     TEXT,
    location        VARCHAR(255),
    price_per_night NUMERIC(10,2),
    created_at      DATE DEFAULT CURRENT_DATE,
    updated_at      DATE DEFAULT CURRENT_DATE,
    user_id         VARCHAR(50),
    review_id       VARCHAR(50),

    CONSTRAINT fk_property_user FOREIGN KEY (user_id) REFERENCES user(user_id),
    CONSTRAINT fk_property_review FOREIGN KEY (review_id) REFERENCES review(review_id)
);

CREATE TABLE review (
    id          SERIAL PRIMARY KEY,
    review_id   VARCHAR(50) UNIQUE NOT NULL,
    property_id VARCHAR(50) NOT NULL,
    user_id     VARCHAR(50) NOT NULL,
    rating      INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment     TEXT,
    created_at  DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES user(user_id),
    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES property(property_id)
);

CREATE TABLE booking (
    id              SERIAL PRIMARY KEY,
    booking_id      VARCHAR(50) UNIQUE NOT NULL,
    property_id     VARCHAR(50) NOT NULL,
    user_id         VARCHAR(50) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    total_price     NUMERIC(10,2) NOT NULL,
    status          VARCHAR(50),
    created_at      DATE DEFAULT CURRENT_DATE,
    payment_id      VARCHAR(50),

    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES user(user_id),
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES property(property_id),
    CONSTRAINT fk_booking_payment FOREIGN KEY (payment_id) REFERENCES payment(payment_id)
);

CREATE TABLE payment (
    id              SERIAL PRIMARY KEY,
    payment_id      VARCHAR(50) UNIQUE NOT NULL,
    booking_id      VARCHAR(50) UNIQUE NOT NULL,
    amount          NUMERIC(10,2) NOT NULL,
    payment_date    DATE DEFAULT CURRENT_DATE,
    payment_method  VARCHAR(50),
    payment_status  VARCHAR(50),

    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

CREATE TABLE message (
    id              SERIAL PRIMARY KEY,
    message_id      VARCHAR(50) UNIQUE NOT NULL,
    sender_id       VARCHAR(50) NOT NULL,
    recipient_id    VARCHAR(50) NOT NULL,
    message_body    TEXT,
    sent_at         DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES user(user_id),
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES user(user_id)
);

CREATE INDEX idx_user_email ON user(email);
CREATE INDEX idx_property_location ON property(location);
CREATE INDEX idx_booking_dates ON booking(start_date, end_date);
CREATE INDEX idx_review_rating ON review(rating);
CREATE INDEX idx_payment_status ON payment(payment_status);
