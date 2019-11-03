DROP TABLE IF EXISTS bids CASCADE;
DROP TABLE IF EXISTS advertised_trips CASCADE;
DROP TABLE IF EXISTS distance_fare CASCADE;
DROP TABLE IF EXISTS location_dist CASCADE;
DROP TABLE IF EXISTS surge CASCADE;
DROP TABLE IF EXISTS membership CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS drives CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;
DROP TABLE IF EXISTS addressbook CASCADE;
DROP TABLE IF EXISTS users CASCADE;
--other functions 
DROP FUNCTION IF EXISTS get_price CASCADE;
DROP FUNCTION IF EXISTS idx CASCADE;
DROP FUNCTION IF EXISTS tie_breaker CASCADE;
DROP FUNCTION IF EXISTS get_membership CASCADE;
DROP FUNCTION IF EXISTS system_selection CASCADE;
--for triggers related
DROP TRIGGER IF EXISTS check_driver_has_advertised_trips_delete_user ON users;
DROP FUNCTION IF EXISTS driver_has_advertised_bid CASCADE;
DROP TRIGGER IF EXISTS check_driver_has_advertised_trip_with_bid_won_uncompleted_trips ON users;
DROP FUNCTION IF EXISTS unable_delete_driver_with_bid_won_uncompleted_trips CASCADE;
DROP TRIGGER IF EXISTS check_passenger_has_trip_with_bid_won_uncompleted_trips ON users;
DROP FUNCTION IF EXISTS unable_delete_passenger_with_bid_won_uncompleted_trips CASCADE;


--SET datestyle = dmy;
ALTER DATABASE "Carpooling" SET datestyle TO "ISO, DMY";

CREATE TABLE  users (
	username VARCHAR(256) PRIMARY KEY,
	password TEXT NOT NULL,
	gender VARCHAR(1) NOT NULL,
	phone_num INTEGER NOT NULL,
	email VARCHAR(256) NOT NULL,
	display_name VARCHAR(256) NOT NULL,
	
	--Username: alphabets or numbers only. 
	Constraint check_username CHECK (username ~ '^[a-zA-Z0-9]*$'),
	
	--Gender: M or F only
	Constraint check_gender CHECK (gender = 'M' or gender = 'F'),
	
	--Phone number: 8 digits only
	Constraint check_phone_num CHECK (phone_num >=10000000 and phone_num <= 99999999),
	
	--Email: contains @ and . and .
	Constraint check_email CHECK (email ~ '^[A-Za-z0-9]+@[A-Za-z0-9]+.[A-Za-z0-9]+.[.]+.*$'),
	
	--Display name: whitespaces, alphabets or numbers only.  
	Constraint check_name CHECK (display_name ~ '^[a-zA-Z0-9\s]*$')
);
/*zhihong8888, password1*/
INSERT INTO users VALUES ('zhihong8888', '$2a$10$dktV2knQRQz0OJVamqR5uOR8uY9IaI7r0NSij3eD8DyXKcpRZyXMS', 'M', '11111111', 'zhihong@gmail.com', 'William Sailor'); 
--hafiz, password2
INSERT INTO users VALUES ('hafiz', '$2a$10$nB9FXcUJVbX9QrfjiHfH4OVFrUZtrzuV.6ul4dxtH11mTm9u8686K', 'M', '22222222', 'hafizuddin@gmail.com', 'Hafiz Derath'); 
--vernon, password3
INSERT INTO users VALUES ('vernon', '$2a$10$QwcmBORGno8g1JS.UcHKD.sG9Y3/zdRWjmtBRlnJh6fRRi87zUFxa', 'M', '33333333', 'vernon@gmail.com', 'BakaEx'); 
--gervaise, password4
INSERT INTO users VALUES ('gervaise', '$2a$10$3BPHPDpXzn0CCVdX0QrpfuvyAmMZLIHnaYnDGi2HiTMBm6HOq4PUm', 'F', '44444444','ger1234@gmail.com', 'HungerTrack'); 
SELECT * FROM USERS;

CREATE TABLE  addressbook (
	postal_code INTEGER NOT NULL,
	username VARCHAR(256) NOT NULL REFERENCES users (username) ON UPDATE CASCADE ON DELETE CASCADE,
	title_of_address VARCHAR(256) NOT NULL,
	address VARCHAR(256) NOT NULL,
	PRIMARY KEY (postal_code, username),
	
	--postal_code: 6 digits only
	Constraint check_postal_code CHECK (postal_code >=100000 and postal_code <= 999999),
		
	--title_of_address: whitespaces, alphabets or numbers only.  
	Constraint check_address CHECK (title_of_address ~ '^[a-zA-Z0-9\s]*$')
);
INSERT INTO addressbook VALUES ('470116', 'zhihong8888', 'Home', 'Blk116 Bedok Reservoir Road #10-92');
INSERT INTO addressbook VALUES ('345116', 'hafiz', 'Work', 'Blk117 Tampines Street 81, 02 #6-92');
INSERT INTO addressbook VALUES ('540329', 'hafiz', 'Home', 'Blk221 329 Anchorvale St #02-02');
INSERT INTO addressbook VALUES ('118425', 'gervaise', 'PGP', '27 Prince George Park, National University of Singapore'); 
SELECT * FROM addressbook;

CREATE TABLE  drivers (
	driver_username VARCHAR(256) PRIMARY KEY REFERENCES users (username) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO drivers VALUES ('hafiz'); 
INSERT INTO drivers VALUES ('vernon'); 
SELECT * FROM DRIVERS;

CREATE TABLE  passengers (
	passenger_username VARCHAR(256) PRIMARY KEY REFERENCES users (username) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO passengers VALUES ('hafiz'); 
INSERT INTO passengers VALUES ('gervaise');
INSERT INTO passengers VALUES ('zhihong8888');
INSERT INTO passengers VALUES ('vernon');
SELECT * FROM PASSENGERS; 


CREATE TABLE  category (
	model VARCHAR(256) PRIMARY KEY,
	type VARCHAR(256) NOT NULL,
	seats_offered INTEGER NOT NULL,

	--model: whitespaces, alphabets or numbers only.  
	Constraint check_model CHECK (model ~ '^[a-zA-Z0-9\s]*$'),
	
	--type: whitespaces, alphabets or numbers only.  
	Constraint check_type CHECK (type ~ '^[a-zA-Z0-9\s]*$'),
	
	--seats_offered: >0
	Constraint check_seats CHECK (seats_offered > 0)
	
);
INSERT INTO category VALUES ('Honda', 'Minibus', '6'); 
INSERT INTO category VALUES ('Mercedes', 'Car', '4');
SELECT * FROM CATEGORY;


CREATE TABLE  vehicles (
	license_plate VARCHAR(256) NOT NULL UNIQUE,
	model VARCHAR(256) REFERENCES category (model) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (license_plate , model),
	
	--license_plate: alphabets or numbers only. 
	Constraint check_license_plate CHECK (license_plate ~ '^[a-zA-Z0-9]*$'),
	
	--model: whitespaces, alphabets or numbers only.  
	Constraint check_model CHECK (model ~ '^[a-zA-Z0-9\s]*$')
);
INSERT INTO vehicles VALUES ('S1234567J', 'Honda'); 
INSERT INTO vehicles VALUES ('S9876542E', 'Mercedes'); 
SELECT * FROM VEHICLES;


CREATE TABLE  drives (
	driver_username VARCHAR(256) REFERENCES drivers (driver_username) ON UPDATE CASCADE ON DELETE CASCADE,
	license_plate VARCHAR(256)  REFERENCES vehicles (license_plate) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (driver_username, license_plate)
	
);
INSERT INTO drives VALUES ('hafiz','S1234567J'); 
INSERT INTO drives VALUES ('hafiz','S9876542E'); 
INSERT INTO drives VALUES ('vernon','S1234567J'); 
INSERT INTO drives VALUES ('vernon','S9876542E'); 
SELECT * FROM drives;


CREATE TABLE  surge (
	time VARCHAR(256) NOT NULL UNIQUE,
	surge_rate numeric NOT NULL,
	
	--time: whitespaces, alphabets or numbers only.  
	Constraint check_time CHECK (time ~ '^[a-zA-Z0-9\s]*$'),
	
	--surge_rate: More than 0
	Constraint check_surge_rate CHECK (surge_rate > 0)
);
INSERT INTO surge VALUES ('Morning Peak', '2'); 
INSERT INTO surge VALUES ('Morning', '1'); 
INSERT INTO surge VALUES ('Afternoon', '1'); 
INSERT INTO surge VALUES ('Evening', '1.5
'); 
INSERT INTO surge VALUES ('Night', '2.5'); 
SELECT * FROM SURGE;

CREATE TABLE  membership (
	category VARCHAR(256) NOT NULL UNIQUE,
	trips_required numeric
	
	--category: whitespaces, alphabets or numbers only.  
	Constraint check_category CHECK (category ~ '^[a-zA-Z0-9\s]*$')
	
);
INSERT INTO membership VALUES ('gold', '10'); 
INSERT INTO membership VALUES ('silver', '5'); 
INSERT INTO membership VALUES ('bronze', '2'); 
INSERT INTO membership VALUES ('green', '0');  
SELECT * FROM membership;


CREATE TABLE location_dist (
	location VARCHAR(256) PRIMARY KEY,
	metrics numeric NOT NULL
);
INSERT INTO location_dist VALUES ('Pasir Ris', '1');
INSERT INTO location_dist VALUES ('Expo', '3');
INSERT INTO location_dist VALUES ('Bedok', '5');
INSERT INTO location_dist VALUES ('City Hall', '7');
INSERT INTO location_dist VALUES ('NUS', '9');
INSERT INTO location_dist VALUES ('Jurong', '11');
INSERT INTO location_dist VALUES ('Boon Lay', '13');
SELECT * FROM location_dist;

CREATE TABLE  distance_fare (
	distance VARCHAR(256) NOT NULL UNIQUE,
	price numeric NOT NULL
	
	--distance: whitespaces, alphabets or numbers only.  
	Constraint check_dist CHECK (distance ~ '^[a-zA-Z0-9\s]*$'),
	
	--price: More than 0
	Constraint check_price CHECK (price > 0)
);
INSERT INTO distance_fare VALUES ('First Km', '3.5'); 
INSERT INTO distance_fare VALUES ('Subsequent Km', '2.5'); 
SELECT * FROM DISTANCE_FARE;


CREATE TABLE advertised_trips (
	driver_username VARCHAR(256) NOT NULL,
	s_location TEXT NOT NULL,
	e_location TEXT NOT NULL,
	s_time TIME NOT NULL,
	e_time TIME NOT NULL,
	s_date DATE NOT NULL,
	e_date DATE NOT NULL,
	license_plate VARCHAR(256) NOT NULL,
	min_bid numeric NOT NULL,
	total_dist numeric NOT NULL,
	driver_rating numeric
	
	--whitespaces, alphabets or numbers only.  
	Constraint check_start_location CHECK (s_location ~ '^[a-zA-Z0-9\s]*$'),
	Constraint check_end_location CHECK (e_location ~ '^[a-zA-Z0-9\s]*$'),
	
	--start < end
	Constraint check_start_end_time CHECK(s_time < e_time),
	Constraint check_start_end_date CHECK(s_date <= e_date),
	
	--start location != end location
	Constraint check_start_end_location CHECK(s_location != e_location),
	
	--More than 0
	Constraint check_min_bid CHECK (min_bid > 0),
	Constraint check_total_dist CHECK (total_dist > 0),
	
	FOREIGN KEY (driver_username, license_plate) 
		REFERENCES drives (driver_username, license_plate)  ON UPDATE CASCADE ON DELETE CASCADE,
		
	PRIMARY KEY(driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate)
);

CREATE TABLE bids (
	bid_price NUMERIC NOT NULL,
	passenger_username VARCHAR(256) NOT NULL REFERENCES passengers (passenger_username) ON UPDATE CASCADE ON DELETE CASCADE,
	
	driver_username VARCHAR(256) NOT NULL REFERENCES drivers (driver_username) ON UPDATE CASCADE ON DELETE CASCADE,
	s_location TEXT NOT NULL REFERENCES location_dist (location) ON UPDATE CASCADE ON DELETE CASCADE,
	e_location TEXT NOT NULL REFERENCES location_dist (location) ON UPDATE CASCADE ON DELETE CASCADE,
	s_time TIME NOT NULL,
	e_time TIME NOT NULL,
	s_date DATE NOT NULL,
	e_date DATE NOT NULL,
	license_plate VARCHAR(256) NOT NULL REFERENCES vehicles (license_plate) ON UPDATE CASCADE ON DELETE CASCADE,
	min_bid NUMERIC NOT NULL,
	total_dist NUMERIC NOT NULL,
	
	is_win BOOLEAN DEFAULT FALSE,
	mode_of_acceptance VARCHAR(256),
	is_completed BOOLEAN DEFAULT FALSE,
	rating NUMERIC,
	bid_time TIMESTAMP
	
	--mode_of_acceptance: 'Driver Selected' OR 'System'
	Constraint check_mode_of_acceptance CHECK (mode_of_acceptance = 'Driver Selected' OR mode_of_acceptance = 'System'),
	
	--More than 0
	Constraint check_bid_price CHECK (bid_price > 0),
	
	--Driver cannot bid himself
	Constraint check_driver_username CHECK (driver_username != passenger_username),
	
	--Cannot have rating without trip completed = true
	Constraint check_rating CHECK ((is_completed is true AND rating is not null) OR (is_completed is false AND rating is null)),
	
	FOREIGN KEY (driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate) 
		REFERENCES advertised_trips (driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate) ON UPDATE CASCADE ON DELETE CASCADE,
		
	PRIMARY KEY (passenger_username, driver_username, license_plate, s_time, e_time, s_date, e_date)
);



CREATE OR REPLACE FUNCTION get_price(dist numeric)
RETURNS numeric
AS $TAG1$
	DECLARE firstKm numeric;
	DECLARE subsequentKm numeric;
	
	BEGIN
		SELECT price INTO firstKm FROM distance_fare WHERE distance_fare.distance = 'First Km';
		SELECT price INTO subsequentKm FROM distance_fare WHERE distance_fare.distance = 'Subsequent Km';
		IF(dist <= 1) THEN
			return firstKm;
		ELSE 
			return firstKm + (dist-1) * subsequentKm;
		END IF;
	END;
$TAG1$  LANGUAGE 'plpgsql';
select get_price(1);



CREATE OR REPLACE FUNCTION idx(anyarray, anyelement)
  RETURNS INT AS 
$$
  SELECT i FROM (
     SELECT generate_series(array_lower($1,1),array_upper($1,1))
  ) g(i)
  WHERE $1[i] = $2
  LIMIT 1;
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION get_membership(name TEXT)
RETURNS TEXT
AS $TAG1$
	DECLARE gold_count numeric;
	DECLARE silver_count numeric;
	DECLARE bronze_count numeric;
	DECLARE green_count numeric;
	
	DECLARE passenger_count numeric;
	
	BEGIN
		SELECT trips_required INTO gold_count FROM membership WHERE category = 'gold';
		SELECT trips_required INTO silver_count FROM membership WHERE category = 'silver';
		SELECT trips_required INTO bronze_count FROM membership WHERE category = 'bronze';
		SELECT trips_required INTO green_count FROM membership WHERE category = 'green';
		
		
		select count(is_completed) INTO passenger_count from bids 
		where is_completed = true and passenger_username = name
		group by passenger_username;
		
		IF(passenger_count >= gold_count) THEN
			return 'gold';
		ELSEIF(passenger_count >= silver_count) THEN
			return 'silver';
		ELSEIF(passenger_count >= bronze_count) THEN
			return 'bronze';
		ELSE
			return 'green';
		END IF;
	END;
$TAG1$  LANGUAGE 'plpgsql';
select get_membership('zhihong8888');


CREATE OR REPLACE FUNCTION tie_breaker(driver TEXT, st_time TIME, en_time TIME, st_date DATE, en_date DATE, license TEXT)
RETURNS Text
AS $func3$
	DECLARE max_bid numeric;
	DECLARE earliest_time TIMESTAMP;
	DECLARE max_category text;
	DECLARE winner_name VARCHAR(256);
	
	BEGIN
		select * from (
			select b.passenger_username, b.bid_price, b.bid_time, get_membership(b.passenger_username) AS membership 
			INTO winner_name, max_bid, earliest_time, max_category from bids b
			where bid_price >= ALL(
				SELECT bid_price from bids bi
				WHERE bi.driver_username = driver
				AND bi.s_time = st_time
				AND bi.e_time = en_time
				AND bi.s_date = st_date
				AND bi.e_date = en_date
				AND bi.license_plate = license
			)
			AND 
			b.driver_username = driver
			AND b.s_time = st_time
			AND b.e_time = en_time
			AND b.s_date = st_date
			AND b.e_date = en_date
			AND b.license_plate = license
		) AS A 
		ORDER BY 
			idx(array['gold','silver','bronze','green'], membership),
			bid_time
		LIMIT 1;

		UPDATE bids SET is_win='t', mode_of_acceptance='System' WHERE bids.driver_username = driver
				AND bids.s_time = st_time
				AND bids.e_time = en_time
				AND bids.s_date = st_date
				AND bids.e_date = en_date
				AND bids.license_plate = license
				AND bids.bid_price = max_bid
				AND bids.bid_time = earliest_time
				AND bids.passenger_username = winner_name;
		RETURN 'clear';

	END;
$func3$  LANGUAGE 'plpgsql';

--Trigger 1
CREATE OR REPLACE FUNCTION driver_has_advertised_bid()
RETURNS TRIGGER AS $TAG2$
	DECLARE count NUMERIC;
	BEGIN
		SELECT COUNT(*) INTO count FROM bids b
		WHERE OLD.username = B.driver_username
		AND B.is_completed = 'false' 
		AND B.is_win = 'false'
		AND B.s_date > now()
		AND B.s_time > to_timestamp(to_char(now(),'HH:MM:SS'),'HH:MM:SS')::time;
		
		
		IF count > 0 THEN	
			RAISE NOTICE 'Bids Trigger 1: Cannot delete driver that has advertised trips';
			PERFORM pg_notify('trigger_error_channel', 'trigger1');
			RETURN NULL; -- prevent
		ELSE
			RETURN OLD; -- allow
		END IF;
	END;
$TAG2$ LANGUAGE plpgsql;
CREATE TRIGGER check_driver_has_advertised_trips_delete_user
BEFORE DELETE ON users 
FOR EACH ROW 
EXECUTE PROCEDURE driver_has_advertised_bid();
--Test trigger 1
--delete from users where username = 'hafiz';
/*
select * from bids where
driver_username = 'hafiz' 
AND is_completed = 'false' 
AND is_win = 'false'
AND s_date > now()
AND s_time > to_timestamp(to_char(now(),'HH:MM:SS'),'HH:MM:SS')::time;
*/

--Trigger 2
CREATE OR REPLACE FUNCTION unable_delete_driver_with_bid_won_uncompleted_trips()
RETURNS TRIGGER AS $TAG3$
	DECLARE count NUMERIC;
	DECLARE myNotice TEXT := 'Bids Trigger 2: Cannont delete driver when there is advertised trip with bid won, but ride is uncompleted';
	BEGIN
		SELECT COUNT(*) INTO count FROM bids b
		WHERE OLD.username = B.driver_username
		AND B.is_completed = 'false' 
		AND B.is_win = 'true';
		
		
		IF count > 0 THEN	
			RAISE NOTICE 'Bids Trigger 2: Cannont delete driver when there is advertised trip with bid won, but ride is uncompleted';
			PERFORM pg_notify('trigger_error_channel', myNotice);
			RETURN NULL; -- prevent
		ELSE
			RETURN OLD; -- allow
		END IF;
	END;
$TAG3$ LANGUAGE plpgsql;
CREATE TRIGGER check_driver_has_advertised_trip_with_bid_won_uncompleted_trips
BEFORE DELETE ON users 
FOR EACH ROW 
EXECUTE PROCEDURE unable_delete_driver_with_bid_won_uncompleted_trips();
--Test trigger 2
--delete from users where username = 'hafiz';
/*
select * from bids where
driver_username = 'hafiz' 
AND is_completed = 'false' 
AND is_win = 'true';
*/

--Trigger 3
CREATE OR REPLACE FUNCTION unable_delete_passenger_with_bid_won_uncompleted_trips()
RETURNS TRIGGER AS $TAG4$
	DECLARE count NUMERIC;
	BEGIN
		SELECT COUNT(*) INTO count FROM bids b
		WHERE OLD.username = B.passenger_username
		AND B.is_completed = 'false' 
		AND B.is_win = 'true';
		
		
		IF count > 0 THEN	
			RAISE NOTICE 'Bids Trigger 3: Cannont delete passenger when there is trip in bids that passenger won, but ride is uncompleted';
			RETURN NULL; -- prevent
		ELSE
			RETURN OLD; -- allow
		END IF;
	END;
$TAG4$ LANGUAGE plpgsql;
CREATE TRIGGER check_passenger_has_trip_with_bid_won_uncompleted_trips
BEFORE DELETE ON users 
FOR EACH ROW 
EXECUTE PROCEDURE unable_delete_passenger_with_bid_won_uncompleted_trips();
--Test trigger 3
--delete from users where username = 'gervaise';
/*
select * from bids where
passenger_username = 'gervaise' 
AND is_completed = 'false' 
AND is_win = 'true';
*/

--Trigger 4
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $TAG5$
BEGIN
	RAISE NOTICE 'Bids Trigger 4: Insert/update timestamp';
  NEW.bid_time = NOW();
  RETURN NEW;
END;
$TAG5$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp
BEFORE INSERT or UPDATE ON bids
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();


INSERT INTO advertised_trips VALUES('vernon', 'Expo', 'NUS', '13:22', '14:22', '19/9/2019', '19/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO advertised_trips VALUES('vernon', 'NUS', 'Bedok', '13:00', '14:22', '20/9/2019', '20/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO advertised_trips VALUES('hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '21/9/2019', '21/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO advertised_trips VALUES('hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '22/9/2019', '22/9/2019', 'S1234567J', '2.9', '1.3');
INSERT INTO advertised_trips VALUES('vernon', 'Expo', 'NUS', '13:22', '14:22', '23/9/2019', '23/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO advertised_trips VALUES('vernon', 'NUS', 'Bedok', '13:00', '14:22', '24/9/2019', '24/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO advertised_trips VALUES('hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '25/9/2019', '25/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO advertised_trips VALUES('hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '26/9/2019', '26/9/2019', 'S1234567J', '2.9', '1.3');
INSERT INTO advertised_trips VALUES('vernon', 'Expo', 'NUS', '13:22', '14:22', '27/9/2019', '27/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO advertised_trips VALUES('vernon', 'NUS', 'Bedok', '13:00', '14:22', '28/9/2019', '28/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO advertised_trips VALUES('hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '29/9/2019', '29/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO advertised_trips VALUES('hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '30/9/2019', '30/9/2019', 'S1234567J', '2.9', '1.3');

INSERT INTO advertised_trips VALUES('hafiz', 'Pasir Ris', 'Boon Lay', '13:22', '14:22', '17/9/2020', '17/9/2020', 'S1234567J', '3.5', '1.2');
INSERT INTO advertised_trips VALUES('hafiz', 'Jurong', 'Expo', '13:00', '14:22', '18/9/2020', '18/9/2020', 'S1234567J', '2.9', '1.3');
INSERT INTO advertised_trips VALUES('hafiz', 'Bedok', 'Expo', '12:00', '13:22', '18/10/2020', '18/10/2020', 'S1234567J', '3.9', '2.3');
--SELECT * FROM advertised_trips;

INSERT INTO bids VALUES('30', 'hafiz', 'vernon', 'Expo', 'NUS', '13:22', '14:22', '19/9/2019', '19/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO bids VALUES('10', 'hafiz', 'vernon', 'NUS', 'Bedok', '13:00', '14:22', '20/9/2019', '20/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO bids VALUES('10', 'vernon', 'hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '21/9/2019', '21/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO bids VALUES('10', 'vernon','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '22/9/2019', '22/9/2019', 'S1234567J', '2.9', '1.3');
INSERT INTO bids VALUES('10', 'gervaise','vernon', 'Expo', 'NUS', '13:22', '14:22', '23/9/2019', '23/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO bids VALUES('10', 'gervaise','vernon', 'NUS', 'Bedok', '13:00', '14:22', '24/9/2019', '24/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO bids VALUES('10', 'zhihong8888','hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '25/9/2019', '25/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO bids VALUES('10', 'zhihong8888','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '26/9/2019', '26/9/2019', 'S1234567J', '2.9', '1.3');
INSERT INTO bids VALUES('10', 'zhihong8888','vernon', 'Expo', 'NUS', '13:22', '14:22', '27/9/2019', '27/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO bids VALUES('10', 'zhihong8888','vernon', 'NUS', 'Bedok', '13:00', '14:22', '28/9/2019', '28/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO bids VALUES('10', 'zhihong8888','hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '29/9/2019', '29/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO bids VALUES('10', 'zhihong8888','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '30/9/2019', '30/9/2019', 'S1234567J', '2.9', '1.3');

INSERT INTO bids VALUES('30', 'gervaise', 'vernon', 'Expo', 'NUS', '13:22', '14:22', '19/9/2019', '19/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO bids VALUES('20', 'gervaise', 'vernon', 'NUS', 'Bedok', '13:00', '14:22', '20/9/2019', '20/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO bids VALUES('20', 'gervaise', 'hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '21/9/2019', '21/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO bids VALUES('20', 'gervaise','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '22/9/2019', '22/9/2019', 'S1234567J', '2.9', '1.3');
INSERT INTO bids VALUES('20', 'hafiz','vernon', 'Expo', 'NUS', '13:22', '14:22', '23/9/2019', '23/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO bids VALUES('20', 'hafiz','vernon', 'NUS', 'Bedok', '13:00', '14:22', '24/9/2019', '24/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO bids VALUES('20', 'vernon','hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '25/9/2019', '25/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO bids VALUES('20', 'vernon','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '26/9/2019', '26/9/2019', 'S1234567J', '2.9', '1.3');
INSERT INTO bids VALUES('20', 'gervaise','vernon', 'Expo', 'NUS', '13:22', '14:22', '27/9/2019', '27/9/2019', 'S9876542E', '3.5', '1.2');
INSERT INTO bids VALUES('20', 'gervaise','vernon', 'NUS', 'Bedok', '13:00', '14:22', '28/9/2019', '28/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO bids VALUES('20', 'gervaise','hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '29/9/2019', '29/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO bids VALUES('20', 'gervaise','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '30/9/2019', '30/9/2019', 'S1234567J', '2.9', '1.3');

INSERT INTO bids VALUES('30', 'zhihong8888', 'vernon', 'Expo', 'NUS', '13:22', '14:22', '19/9/2019', '19/9/2019', 'S9876542E', '3.5', '1.2', 'true', 'System', 'true', '5');
INSERT INTO bids VALUES('30', 'zhihong8888', 'vernon', 'NUS', 'Bedok', '13:00', '14:22', '20/9/2019', '20/9/2019', 'S9876542E', '2.9', '1.3', 'true', 'System', 'true', '3');
INSERT INTO bids VALUES('30', 'zhihong8888', 'hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '21/9/2019', '21/9/2019', 'S1234567J', '3.5', '1.2', 'true', 'System', 'true', '5');
INSERT INTO bids VALUES('30', 'zhihong8888','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '22/9/2019', '22/9/2019', 'S1234567J', '2.9', '1.3', 'true', 'System', 'true', '4');
INSERT INTO bids VALUES('30', 'zhihong8888','vernon', 'Expo', 'NUS', '13:22', '14:22', '23/9/2019', '23/9/2019', 'S9876542E', '3.5', '1.2', 'true', 'System', 'true', '5');
INSERT INTO bids VALUES('30', 'zhihong8888','vernon', 'NUS', 'Bedok', '13:00', '14:22', '24/9/2019', '24/9/2019', 'S9876542E', '2.9', '1.3', 'true', 'System', 'true', '4');
INSERT INTO bids VALUES('30', 'gervaise','hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '25/9/2019', '25/9/2019', 'S1234567J', '3.5', '1.2', 'true', 'System', 'true', '3');
INSERT INTO bids VALUES('30', 'gervaise','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '26/9/2019', '26/9/2019', 'S1234567J', '2.9', '1.3', 'true', 'System', 'true', '4');
INSERT INTO bids VALUES('30', 'hafiz','vernon', 'Expo', 'NUS', '13:22', '14:22', '27/9/2019', '27/9/2019', 'S9876542E', '3.5', '1.2', 'true', 'System', 'true', '3');
INSERT INTO bids VALUES('30', 'hafiz','vernon', 'NUS', 'Bedok', '13:00', '14:22', '28/9/2019', '28/9/2019', 'S9876542E', '2.9', '1.3');
INSERT INTO bids VALUES('30', 'vernon','hafiz', 'Pasir Ris', 'NUS', '13:22', '14:22', '29/9/2019', '29/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO bids VALUES('30', 'vernon','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '30/9/2019', '30/9/2019', 'S1234567J', '2.9', '1.3');
INSERT INTO bids VALUES('30', 'gervaise','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '30/9/2019', '30/9/2019', 'S1234567J', '2.9', '1.3');


INSERT INTO bids (bid_price, passenger_username, driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, total_dist, is_win, mode_of_acceptance, is_completed, rating) VALUES('10', 'gervaise', 'hafiz', 'Pasir Ris', 'Boon Lay', '13:22', '14:22', '17/9/2020', '17/9/2020', 'S1234567J', '3.5', '1.2', 'true', 'System', 'true', '3');
INSERT INTO bids (bid_price, passenger_username, driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, total_dist) VALUES('10', 'gervaise', 'hafiz', 'Jurong', 'Expo', '13:00', '14:22', '18/9/2020', '18/9/2020', 'S1234567J', '2.9', '1.3');
INSERT INTO bids (bid_price, passenger_username, driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, total_dist, is_win, mode_of_acceptance, is_completed) VALUES('10', 'gervaise', 'hafiz', 'Bedok', 'Expo', '12:00', '13:22', '18/10/2020', '18/10/2020', 'S1234567J', '3.9', '2.3', 'true', 'System', 'false');

--SELECT * FROM BIDS;


--trigger 5
CREATE OR REPLACE FUNCTION system_selection()
RETURNS TRIGGER 
AS $TAG2$
	DECLARE max_bid numeric;
	DECLARE earliest_time TIMESTAMP;
	DECLARE max_category text;
	DECLARE winner_name VARCHAR(256);
	
	BEGIN
		PERFORM tie_breaker(driver_username, s_time, e_time, s_date, e_date, license_plate) from (
			SELECT driver_username, s_time, e_time, s_date, e_date, license_plate, count(is_win) AS counter from bids
			WHERE is_win = 'false' 
			group by (driver_username, s_time, e_time, s_date, e_date, license_plate)
		) AS A1
		WHERE A1.counter >=3;
		RETURN NEW; -- allow
	END;
$TAG2$  LANGUAGE 'plpgsql';
CREATE TRIGGER check_ties
BEFORE INSERT ON bids 
FOR EACH ROW 
EXECUTE PROCEDURE system_selection();


--test system selection()
/*
select * from (
	SELECT driver_username, s_time, e_time, s_date, e_date, license_plate, count(is_win) AS counter from bids
	WHERE is_win = 'false' 
	group by (driver_username, s_time, e_time, s_date, e_date, license_plate)
) AS A1
WHERE A1.counter >=3;

select * from bids where is_completed = false and is_win = true;

--user1, password
INSERT INTO users VALUES ('user1', '$2a$10$tpJ3Awz2WBRaDjpC4z4s9O3nwZ78/4Ne3WnmBhzuQ7RBo9doaR7TG', 'F', '44444444','ger1234@gmail.com', 'HungerTrack'); 
INSERT INTO passengers VALUES ('user1'); 
INSERT INTO bids VALUES('30', 'user1','hafiz', 'NUS', 'Boon Lay', '13:00', '14:22', '30/9/2019', '30/9/2019', 'S1234567J', '2.9', '1.3');

*/