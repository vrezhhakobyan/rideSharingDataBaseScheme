DROP TABLE IF EXISTS gps_location_data, ride_receipts, support_tickets, complaints, ratings, insurance_details, bank_cards, rides, registered_cars, reports, riders, drivers CASCADE;


CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    profile_pic TEXT,
    customer_base NUMERIC(5,2),
    rating NUMERIC(3,2) DEFAULT 0
);


CREATE TABLE riders (
    rider_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    profile_pic TEXT,
    location VARCHAR(200)
);


CREATE TABLE registered_cars (
    car_id SERIAL PRIMARY KEY,
    driver_id INTEGER NOT NULL,
    car_number VARCHAR(20) NOT NULL UNIQUE,
    color VARCHAR(100),
    license_plate VARCHAR(20),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);


CREATE TABLE rides (
    ride_id SERIAL PRIMARY KEY,
    rider_id INTEGER NOT NULL,
    driver_id INTEGER NOT NULL,
    car_id INTEGER NOT NULL,
    pickup_location TEXT NOT NULL,
    drop_location TEXT NOT NULL,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    cost_estimate NUMERIC(10,2),
    status VARCHAR(50) CHECK (status IN ('en_route', 'completed', 'canceled')),
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY (car_id) REFERENCES registered_cars(car_id)
);


CREATE TABLE complaints (
    complaint_id SERIAL PRIMARY KEY,
    rider_id INTEGER NOT NULL,
    reporter_id INTEGER NOT NULL,
    reported_id INTEGER NOT NULL,
    complaint_details TEXT,
    date_reported TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id),
    FOREIGN KEY (reporter_id) REFERENCES riders(rider_id),
    FOREIGN KEY (reported_id) REFERENCES drivers(driver_id)
);

CREATE TABLE bank_cards (
    card_id SERIAL PRIMARY KEY,
    rider_id INTEGER NOT NULL,
    card_number VARCHAR(50) NOT NULL,
    expiry VARCHAR(10) NOT NULL,
    card_type VARCHAR(20) NOT NULL,
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);

CREATE TABLE ride_receipts (
    ride_id INTEGER PRIMARY KEY, 
    fare NUMERIC(10,2),
    tip NUMERIC(10,2),
    total NUMERIC(10,2),
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id) ON DELETE CASCADE
);



CREATE TABLE gps_location_data (
    ride_id INTEGER NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    PRIMARY KEY (ride_id, timestamp),
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id) ON DELETE CASCADE
);

CREATE TABLE rated_in (
    ride_id INTEGER NOT NULL,
    driver_id INTEGER NOT NULL,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    PRIMARY KEY (ride_id, driver_id),
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);


CREATE TABLE support_tickets (
    ticket_id SERIAL PRIMARY KEY,
    rider_id INTEGER NOT NULL,
    issue TEXT NOT NULL,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);

CREATE TABLE insurance_details (
    car_id INTEGER NOT NULL,
    provider VARCHAR(100) NOT NULL,
    policy_number VARCHAR(50) NOT NULL,
    start_date TIMESTAMP NOT NULL,
    expiry_date TIMESTAMP NOT NULL,
    PRIMARY KEY (car_id, start_date),
    FOREIGN KEY (car_id) REFERENCES registered_cars(car_id) ON DELETE CASCADE
);


