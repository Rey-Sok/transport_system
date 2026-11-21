-- =====================================================================
-- Transport Management System - PostgreSQL schema (corrected)
-- Naming: snake_case, singular table names
-- Run: psql -U postgres -d transport_db -f transport_system.sql
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS btree_gist;   -- needed for overlap exclusion constraints
CREATE EXTENSION IF NOT EXISTS citext;       -- case-insensitive email

-- ---------------------------------------------------------------------
-- Helper: auto-update updated_at
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- 1. ACCOUNTS
-- =====================================================================

-- USER renamed to passenger (USER is a reserved word)
CREATE TABLE passenger (
    passenger_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name        VARCHAR(50)  NOT NULL,
    last_name         VARCHAR(50)  NOT NULL,
    gender            VARCHAR(10)  CHECK (gender IN ('M','F','Other')),
    nationality       VARCHAR(50),
    email             CITEXT       NOT NULL UNIQUE,
    password_hash     VARCHAR(255),                      -- NULL for social login
    phone_number      VARCHAR(20),
    auth_provider     VARCHAR(20)  NOT NULL DEFAULT 'local'
                      CHECK (auth_provider IN ('local','google','facebook')),
    auth_provider_id  VARCHAR(100),
    profile_image     VARCHAR(255),
    status            VARCHAR(10)  NOT NULL DEFAULT 'active'
                      CHECK (status IN ('active','inactive')),
    last_login_at     TIMESTAMPTZ,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (auth_provider, auth_provider_id),
    CONSTRAINT chk_passenger_auth CHECK (
        (auth_provider = 'local'  AND password_hash IS NOT NULL)
     OR (auth_provider <> 'local' AND auth_provider_id IS NOT NULL)
    )
);
CREATE TRIGGER trg_passenger_updated BEFORE UPDATE ON passenger
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE role (
    role_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_name    VARCHAR(50)  NOT NULL UNIQUE,           -- Admin, Manager, Receptionist, Driver
    description  VARCHAR(255)
);

CREATE TABLE permission (
    permission_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    permission_name  VARCHAR(100) NOT NULL UNIQUE,
    module           VARCHAR(50)  NOT NULL,              -- booking, vehicle, report ...
    action           VARCHAR(20)  NOT NULL
                     CHECK (action IN ('view','create','edit','delete','export')),
    UNIQUE (module, action)
);

CREATE TABLE role_permission (
    role_id        INT NOT NULL REFERENCES role(role_id)             ON DELETE CASCADE,
    permission_id  INT NOT NULL REFERENCES permission(permission_id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE staff (
    staff_id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_id        INT          NOT NULL REFERENCES role(role_id),
    first_name     VARCHAR(50)  NOT NULL,
    last_name      VARCHAR(50)  NOT NULL,
    email          CITEXT       NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    phone_number   VARCHAR(20),
    status         VARCHAR(10)  NOT NULL DEFAULT 'active'
                   CHECK (status IN ('active','inactive')),
    last_login_at  TIMESTAMPTZ,
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ  NOT NULL DEFAULT now()
);
CREATE INDEX idx_staff_role ON staff(role_id);
CREATE TRIGGER trg_staff_updated BEFORE UPDATE ON staff
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Driver = subtype of staff (role should be 'Driver' - validate in backend)
CREATE TABLE driver (
    staff_id        INT PRIMARY KEY REFERENCES staff(staff_id) ON DELETE CASCADE,
    license_number  VARCHAR(50) NOT NULL UNIQUE,
    license_expiry  DATE        NOT NULL,
    status          VARCHAR(15) NOT NULL DEFAULT 'available'
                    CHECK (status IN ('available','on_trip','unavailable')),
    rating_avg      NUMERIC(3,2) CHECK (rating_avg BETWEEN 0 AND 5)
);

-- Auth helper tables
CREATE TABLE password_reset_token (
    token_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    passenger_id  INT  REFERENCES passenger(passenger_id) ON DELETE CASCADE,
    staff_id      INT  REFERENCES staff(staff_id)         ON DELETE CASCADE,
    token_hash    VARCHAR(255) NOT NULL UNIQUE,
    expires_at    TIMESTAMPTZ  NOT NULL,
    used_at       TIMESTAMPTZ,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CHECK (num_nonnulls(passenger_id, staff_id) = 1)
);

CREATE TABLE refresh_token (
    token_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    passenger_id  INT  REFERENCES passenger(passenger_id) ON DELETE CASCADE,
    staff_id      INT  REFERENCES staff(staff_id)         ON DELETE CASCADE,
    token_hash    VARCHAR(255) NOT NULL UNIQUE,
    expires_at    TIMESTAMPTZ  NOT NULL,
    revoked_at    TIMESTAMPTZ,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CHECK (num_nonnulls(passenger_id, staff_id) = 1)
);

CREATE TABLE device_token (                               -- push notification (FCM/APNs)
    device_token_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    passenger_id     INT NOT NULL REFERENCES passenger(passenger_id) ON DELETE CASCADE,
    token            VARCHAR(255) NOT NULL UNIQUE,
    platform         VARCHAR(10)  NOT NULL CHECK (platform IN ('android','ios')),
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- =====================================================================
-- 2. VEHICLES & SEATS
-- =====================================================================
CREATE TABLE vehicle_type (
    vehicle_type_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_name        VARCHAR(50) NOT NULL UNIQUE,         -- Bus, Van, Car
    description      VARCHAR(255)
);

CREATE TABLE vehicle (
    vehicle_id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vehicle_type_id  INT         NOT NULL REFERENCES vehicle_type(vehicle_type_id),
    license_plate    VARCHAR(20) NOT NULL UNIQUE,
    vehicle_class    VARCHAR(10) NOT NULL DEFAULT 'normal'
                     CHECK (vehicle_class IN ('normal','vip')),
    seat_capacity    INT         NOT NULL CHECK (seat_capacity > 0),
    facilities       JSONB       NOT NULL DEFAULT '[]',   -- ["wifi","ac","usb"]
    image            VARCHAR(255),
    status           VARCHAR(15) NOT NULL DEFAULT 'available'
                     CHECK (status IN ('available','maintenance','inactive')),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_vehicle_type ON vehicle(vehicle_type_id);

CREATE TABLE seat (
    seat_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vehicle_id   INT         NOT NULL REFERENCES vehicle(vehicle_id) ON DELETE CASCADE,
    seat_number  VARCHAR(10) NOT NULL,                    -- A1, B2
    seat_row     INT         NOT NULL,
    seat_column  INT         NOT NULL,
    UNIQUE (vehicle_id, seat_number),
    UNIQUE (vehicle_id, seat_row, seat_column)
);

-- =====================================================================
-- 3. LOCATIONS, ROUTES, STOPS
-- =====================================================================
CREATE TABLE location (                                   -- city / province
    location_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE,
    name_km      VARCHAR(100),
    latitude     NUMERIC(10,7),
    longitude    NUMERIC(10,7)
);

CREATE TABLE route (
    route_id            INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    origin_id           INT NOT NULL REFERENCES location(location_id),
    destination_id      INT NOT NULL REFERENCES location(location_id),
    distance_km         NUMERIC(7,2) NOT NULL CHECK (distance_km > 0),
    estimated_duration  INTERVAL     NOT NULL,            -- static estimate, entered manually
    status              VARCHAR(10)  NOT NULL DEFAULT 'active'
                        CHECK (status IN ('active','inactive')),
    UNIQUE (origin_id, destination_id),
    CHECK (origin_id <> destination_id)
);

CREATE TABLE route_stop (
    stop_id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    route_id         INT          NOT NULL REFERENCES route(route_id) ON DELETE CASCADE,
    stop_name        VARCHAR(100) NOT NULL,
    stop_order       INT          NOT NULL CHECK (stop_order >= 0),
    arrival_offset   INTERVAL     NOT NULL DEFAULT '0',   -- time from origin
    address          VARCHAR(255),
    latitude         NUMERIC(10,7),
    longitude        NUMERIC(10,7),
    google_place_id  VARCHAR(150),
    UNIQUE (route_id, stop_order)
);

-- =====================================================================
-- 4. TRIPS & TRIP SEATS
-- =====================================================================
CREATE TABLE trip (
    trip_id             INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    route_id            INT NOT NULL REFERENCES route(route_id),
    vehicle_id          INT NOT NULL REFERENCES vehicle(vehicle_id),
    driver_id           INT NOT NULL REFERENCES driver(staff_id),
    departure_datetime  TIMESTAMPTZ   NOT NULL,
    arrival_datetime    TIMESTAMPTZ   NOT NULL,           -- may fall on the next day
    ticket_price        NUMERIC(10,2) NOT NULL CHECK (ticket_price >= 0),
    discount_percent    NUMERIC(5,2)  NOT NULL DEFAULT 0
                        CHECK (discount_percent BETWEEN 0 AND 100),
    final_price         NUMERIC(10,2) GENERATED ALWAYS AS
                        (ROUND(ticket_price * (1 - discount_percent / 100), 2)) STORED,
    status              VARCHAR(15) NOT NULL DEFAULT 'scheduled'
                        CHECK (status IN ('scheduled','ongoing','completed','cancelled')),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (arrival_datetime > departure_datetime),
    -- a vehicle / driver cannot be on two overlapping trips
    CONSTRAINT trip_vehicle_no_overlap EXCLUDE USING gist (
        vehicle_id WITH =,
        tstzrange(departure_datetime, arrival_datetime) WITH &&
    ) WHERE (status <> 'cancelled'),
    CONSTRAINT trip_driver_no_overlap EXCLUDE USING gist (
        driver_id WITH =,
        tstzrange(departure_datetime, arrival_datetime) WITH &&
    ) WHERE (status <> 'cancelled')
);
CREATE INDEX idx_trip_search ON trip(route_id, departure_datetime);
CREATE INDEX idx_trip_driver  ON trip(driver_id);
CREATE INDEX idx_trip_vehicle ON trip(vehicle_id);

CREATE TABLE trip_seat (
    trip_seat_id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    trip_id              INT NOT NULL REFERENCES trip(trip_id) ON DELETE CASCADE,
    seat_id              INT NOT NULL REFERENCES seat(seat_id),
    status               VARCHAR(10) NOT NULL DEFAULT 'available'
                         CHECK (status IN ('available','held','booked','blocked')),
    held_by_passenger_id INT REFERENCES passenger(passenger_id) ON DELETE SET NULL,
    hold_expires_at      TIMESTAMPTZ,
    UNIQUE (trip_id, seat_id),
    CHECK (status <> 'held' OR hold_expires_at IS NOT NULL)
);
CREATE INDEX idx_trip_seat_status ON trip_seat(trip_id, status);

-- Auto-generate trip_seat rows when a trip is created
CREATE OR REPLACE FUNCTION create_trip_seats() RETURNS trigger AS $$
BEGIN
    INSERT INTO trip_seat (trip_id, seat_id)
    SELECT NEW.trip_id, s.seat_id FROM seat s WHERE s.vehicle_id = NEW.vehicle_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_trip_create_seats AFTER INSERT ON trip
    FOR EACH ROW EXECUTE FUNCTION create_trip_seats();

-- =====================================================================
-- 5. BOOKING, PAYMENT, INVOICE
-- =====================================================================
CREATE TABLE booking (
    booking_id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    passenger_id      INT REFERENCES passenger(passenger_id),     -- NULL for walk-in / phone
    staff_id          INT REFERENCES staff(staff_id),             -- set when staff creates it
    trip_id           INT NOT NULL REFERENCES trip(trip_id),
    boarding_stop_id  INT REFERENCES route_stop(stop_id),
    dropoff_stop_id   INT REFERENCES route_stop(stop_id),
    passenger_name    VARCHAR(100),
    passenger_phone   VARCHAR(20),
    booking_code      VARCHAR(20)   NOT NULL UNIQUE,
    qr_code           VARCHAR(255),
    total_amount      NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    booking_status    VARCHAR(15)   NOT NULL DEFAULT 'pending'
                      CHECK (booking_status IN ('pending','confirmed','cancelled','completed')),
    booking_date      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    expires_at        TIMESTAMPTZ,                                -- unpaid pending bookings
    cancelled_at      TIMESTAMPTZ,
    cancel_reason     VARCHAR(255),
    CONSTRAINT chk_booking_passenger CHECK (
        passenger_id IS NOT NULL
        OR (passenger_name IS NOT NULL AND passenger_phone IS NOT NULL)
    ),
    CONSTRAINT chk_booking_stops CHECK (
        boarding_stop_id IS NULL OR dropoff_stop_id IS NULL
        OR boarding_stop_id <> dropoff_stop_id
    )
);
CREATE INDEX idx_booking_passenger ON booking(passenger_id);
CREATE INDEX idx_booking_trip      ON booking(trip_id);
CREATE INDEX idx_booking_status    ON booking(booking_status);

CREATE TABLE booking_seat (
    booking_seat_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id       INT NOT NULL REFERENCES booking(booking_id) ON DELETE CASCADE,
    trip_seat_id     INT NOT NULL REFERENCES trip_seat(trip_seat_id),
    price            NUMERIC(10,2) NOT NULL CHECK (price >= 0),    -- price snapshot
    is_active        BOOLEAN NOT NULL DEFAULT TRUE                 -- FALSE after cancel
);
-- A seat can be actively booked only once, but history rows are kept after cancel
CREATE UNIQUE INDEX uq_booking_seat_active ON booking_seat(trip_seat_id) WHERE is_active;
CREATE INDEX idx_booking_seat_booking ON booking_seat(booking_id);

CREATE TABLE payment_method (
    payment_method_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code               VARCHAR(30) NOT NULL UNIQUE,                -- aba, khqr, card, cash
    name               VARCHAR(50) NOT NULL,
    is_active          BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE payment (
    payment_id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id         INT NOT NULL REFERENCES booking(booking_id),
    payment_method_id  INT NOT NULL REFERENCES payment_method(payment_method_id),
    amount             NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    currency           CHAR(3)       NOT NULL DEFAULT 'USD' CHECK (currency IN ('USD','KHR')),
    payment_status     VARCHAR(10)   NOT NULL DEFAULT 'pending'
                       CHECK (payment_status IN ('pending','success','failed','refunded','partial_refunded')),
    transaction_ref    VARCHAR(100) UNIQUE,
    paid_at            TIMESTAMPTZ,                                -- NULL until paid
    refund_amount      NUMERIC(10,2) NOT NULL DEFAULT 0,
    refunded_at        TIMESTAMPTZ,
    created_at         TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CHECK (refund_amount >= 0 AND refund_amount <= amount),
    CHECK (payment_status <> 'success' OR paid_at IS NOT NULL)
);
CREATE INDEX idx_payment_booking ON payment(booking_id);
CREATE INDEX idx_payment_status  ON payment(payment_status);

CREATE TABLE invoice (
    invoice_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    payment_id      INT         NOT NULL UNIQUE REFERENCES payment(payment_id),
    invoice_number  VARCHAR(30) NOT NULL UNIQUE,
    issued_date     TIMESTAMPTZ NOT NULL DEFAULT now(),
    invoice_file    VARCHAR(255)
);

-- =====================================================================
-- 6. NOTIFICATIONS
-- =====================================================================
CREATE TABLE notification_template (
    template_id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name              VARCHAR(100) NOT NULL,
    type              VARCHAR(30)  NOT NULL UNIQUE
                      CHECK (type IN ('booking_confirmation','payment_confirmation',
                                      'trip_reminder','departure_reminder',
                                      'cancellation','schedule_change')),
    content_template  TEXT NOT NULL
);

CREATE TABLE notification (
    notification_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    template_id      INT REFERENCES notification_template(template_id),
    passenger_id     INT REFERENCES passenger(passenger_id) ON DELETE CASCADE,
    staff_id         INT REFERENCES staff(staff_id)         ON DELETE CASCADE,
    booking_id       INT REFERENCES booking(booking_id)     ON DELETE SET NULL,
    trip_id          INT REFERENCES trip(trip_id)           ON DELETE SET NULL,
    title            VARCHAR(150) NOT NULL,
    message          TEXT         NOT NULL,
    is_read          BOOLEAN      NOT NULL DEFAULT FALSE,
    sent_at          TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CHECK (num_nonnulls(passenger_id, staff_id) = 1)
);
CREATE INDEX idx_notification_passenger ON notification(passenger_id, is_read);
CREATE INDEX idx_notification_staff     ON notification(staff_id, is_read);

-- =====================================================================
-- 7. RATING (driver is derived: booking -> trip -> driver)
-- =====================================================================
CREATE TABLE rating (
    rating_id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id      INT NOT NULL UNIQUE REFERENCES booking(booking_id),  -- 1 rating / booking
    passenger_id    INT NOT NULL REFERENCES passenger(passenger_id),
    vehicle_rating  SMALLINT NOT NULL CHECK (vehicle_rating  BETWEEN 1 AND 5),
    driver_rating   SMALLINT NOT NULL CHECK (driver_rating   BETWEEN 1 AND 5),
    service_rating  SMALLINT NOT NULL CHECK (service_rating  BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Keep driver.rating_avg up to date
CREATE OR REPLACE FUNCTION refresh_driver_rating() RETURNS trigger AS $$
DECLARE v_driver INT;
BEGIN
    SELECT t.driver_id INTO v_driver
    FROM booking b JOIN trip t ON t.trip_id = b.trip_id
    WHERE b.booking_id = NEW.booking_id;

    UPDATE driver SET rating_avg = (
        SELECT ROUND(AVG(r.driver_rating), 2)
        FROM rating r
        JOIN booking b ON b.booking_id = r.booking_id
        JOIN trip t    ON t.trip_id    = b.trip_id
        WHERE t.driver_id = v_driver
    ) WHERE staff_id = v_driver;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_rating_driver AFTER INSERT OR UPDATE ON rating
    FOR EACH ROW EXECUTE FUNCTION refresh_driver_rating();


CREATE TABLE audit_log (
    audit_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staff_id     INT REFERENCES staff(staff_id) ON DELETE SET NULL,
    action       VARCHAR(50)  NOT NULL,                 -- e.g. booking.cancel, payment.refund
    entity       VARCHAR(50)  NOT NULL,
    entity_id    VARCHAR(50),
    details      JSONB,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT now()
);
CREATE INDEX idx_audit_entity ON audit_log(entity, entity_id);

-- =====================================================================
-- SEED DATA
-- =====================================================================
INSERT INTO role (role_name, description) VALUES
    ('Admin',        'Full access'),
    ('Manager',      'Manage operations and reports'),
    ('Receptionist', 'Create and manage bookings'),
    ('Driver',       'Driver account');

INSERT INTO vehicle_type (type_name) VALUES ('Bus'), ('Van'), ('Car');

INSERT INTO payment_method (code, name) VALUES
    ('aba',  'ABA Pay'),
    ('khqr', 'KHQR');

INSERT INTO notification_template (name, type, content_template) VALUES
    ('Booking confirmed',  'booking_confirmation', 'Your booking {{booking_code}} is confirmed.'),
    ('Payment received',   'payment_confirmation', 'We received your payment of {{amount}}.'),
    ('Trip reminder',      'trip_reminder',        'Your trip is tomorrow at {{departure_time}}.'),
    ('Departure reminder', 'departure_reminder',   'Your bus departs in 1 hour.'),
    ('Booking cancelled',  'cancellation',         'Booking {{booking_code}} was cancelled.'),
    ('Schedule changed',   'schedule_change',      'Your trip schedule has changed.');