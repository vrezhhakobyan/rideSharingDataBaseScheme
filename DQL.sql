-- Ride-Sharing System – DQL & Triggers

-------------------------------
-- User Management
-------------------------------

-- Get all riders
SELECT *
FROM riders;


-------------------------------
-- Vehicle Management
-------------------------------

-- Get all cars and their drivers
SELECT c.car_id, c.car_number, c.color, c.license_plate, d.name AS driver_name
FROM registered_cars c
JOIN drivers d ON c.driver_id = d.driver_id;

-- Get insurance details for a specific car
SELECT * 
FROM insurance_details 
WHERE car_id = 1;

-- Check for expired insurance policies
SELECT * 
FROM insurance_details 
WHERE expiry_date < CURRENT_DATE;


-------------------------------
-- Ride Management
-------------------------------

-- Get all rides for a rider
SELECT * 
FROM rides 
WHERE rider_id = 10
ORDER BY start_time DESC;

-- Get current active rides (status = 'en_route')
SELECT * 
FROM rides 
WHERE status = 'en_route';

-- Get ride history for a driver
SELECT * 
FROM rides 
WHERE driver_id = 5
ORDER BY start_time DESC;


-------------------------------
-- Financial Operations
-------------------------------

-- Get all bank cards for a rider
SELECT * 
FROM bank_cards
WHERE rider_id = 10;

-- Get ride receipt for a specific ride
SELECT * 
FROM ride_receipts 
WHERE ride_id = 16;

-- Get total earnings by driver
SELECT driver_id, SUM(fare) AS total_fare, SUM(tip) AS total_tips, SUM(total) AS total_earnings
FROM ride_receipts
JOIN rides ON rides.ride_id = ride_receipts.ride_id
GROUP BY driver_id;


-------------------------------
-- Feedback and Support
-------------------------------

-- Get all ratings for a driver
SELECT ride_id, rating, comment
FROM rated_in
WHERE driver_id = 12;

-- Get all complaints about a driver
SELECT * 
FROM complaints 
WHERE reported_id = 15;

-- Get all support tickets for a rider
SELECT * 
FROM support_tickets 
WHERE rider_id = 80;


-------------------------------
-- Reporting and Analytics
-------------------------------

-- Get monthly revenue per driver
SELECT d.driver_id, d.name,
       DATE_TRUNC('month', r.end_time) AS month,
       SUM(rr.total) AS monthly_total
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
JOIN ride_receipts rr ON r.ride_id = rr.ride_id
WHERE r.status = 'completed'
GROUP BY d.driver_id, d.name, month
ORDER BY month DESC;

-- Get top 10 popular drop-off locations
SELECT drop_location, COUNT(*) AS total_dropoffs
FROM rides
GROUP BY drop_location
ORDER BY total_dropoffs DESC
LIMIT 10;

-- Check driver availability (drivers not currently en_route)
SELECT d.driver_id, d.name
FROM drivers d
WHERE d.driver_id NOT IN (
    SELECT driver_id
    FROM rides
    WHERE status = 'en_route'
);



-------------------------------
-- Triggers
-------------------------------

-- Prevent duplicate emails when updating riders
CREATE OR REPLACE FUNCTION check_unique_email_riders()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM riders
        WHERE email = NEW.email AND rider_id != OLD.rider_id
    ) THEN
        RAISE EXCEPTION 'Email already exists for another rider';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_unique_email_riders
BEFORE UPDATE ON riders
FOR EACH ROW
EXECUTE FUNCTION check_unique_email_riders();


-- Auto-update driver rating after a new rating
CREATE OR REPLACE FUNCTION update_driver_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE drivers
    SET rating = (
        SELECT AVG(rating)
        FROM rated_in
        WHERE driver_id = NEW.driver_id
    )
    WHERE driver_id = NEW.driver_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_driver_rating
AFTER INSERT OR UPDATE ON rated_in
FOR EACH ROW
EXECUTE FUNCTION update_driver_rating();


-- Auto-calculate total amount (fare + tip) in ride receipt
CREATE OR REPLACE FUNCTION calc_total_receipt()
RETURNS TRIGGER AS $$
BEGIN
    NEW.total := COALESCE(NEW.fare, 0) + COALESCE(NEW.tip, 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calc_total_receipt
BEFORE INSERT OR UPDATE ON ride_receipts
FOR EACH ROW
EXECUTE FUNCTION calc_total_receipt();



