DROP TABLE IF EXISTS bids CASCADE;
DROP TABLE IF EXISTS advertised_trips CASCADE;
DROP TABLE IF EXISTS distance_fare CASCADE;
DROP TABLE IF EXISTS location_dist CASCADE;
DROP TABLE IF EXISTS surge CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;
DROP TABLE IF EXISTS addressbook CASCADE;
DROP TABLE IF EXISTS users CASCADE;

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
	driver_username VARCHAR(256) REFERENCES drivers (driver_username) ON UPDATE CASCADE ON DELETE CASCADE,
	license_plate VARCHAR(256) NOT NULL UNIQUE,
	model VARCHAR(256) REFERENCES category (model) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (driver_username, license_plate , model),
	
	--license_plate: alphabets or numbers only. 
	Constraint check_license_plate CHECK (license_plate ~ '^[a-zA-Z0-9]*$')
);
INSERT INTO vehicles VALUES ('hafiz','S1234567J', 'Honda'); 
INSERT INTO vehicles VALUES ('hafiz''S9876542E', 'Mercedes'); 
INSERT INTO vehicles VALUES ('vernon','S1234567J', 'Honda'); 
INSERT INTO vehicles VALUES ('vernon','S9876542E', 'Mercedes'); 
SELECT * FROM VEHICLES;


CREATE TABLE  surge (
	time VARCHAR(256) NOT NULL UNIQUE,
	surge_rate numeric NOT NULL,
	
	--time: whitespaces, alphabets or numbers only.  
	Constraint check_time CHECK (time ~ '^[a-zA-Z0-9\s]*$'),
	
	--surge_rate: More than 0
	Constraint check_surge_rate CHECK (surge_rate > 0)
);
INSERT INTO surge VALUES ('Morning Peak', '1.5'); 
INSERT INTO surge VALUES ('Morning', '1'); 
INSERT INTO surge VALUES ('Afternoon', '2'); 
INSERT INTO surge VALUES ('Evening', '3.5'); 
INSERT INTO surge VALUES ('Night', '4'); 
SELECT * FROM SURGE;

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


CREATE TABLE  distance_fare (
	distance VARCHAR(256) NOT NULL UNIQUE,
	price numeric NOT NULL
	
	--distance: whitespaces, alphabets or numbers only.  
	Constraint check_dist CHECK (distance ~ '^[a-zA-Z0-9\s]*$'),
	
	--price: More than 0
	Constraint check_price CHECK (price > 0)
);
INSERT INTO distance_fare VALUES ('First Km', '3.5'); 
INSERT INTO distance_fare VALUES ('Next 4 Km', '2.9'); 
INSERT INTO distance_fare VALUES ('Subsequent Km', '2.5'); 
SELECT * FROM DISTANCE_FARE;


DROP TABLE IF EXISTS bids CASCADE;
DROP TABLE IF EXISTS advertised_trips CASCADE;
CREATE TABLE advertised_trips (
	driver_username VARCHAR(256) NOT NULL REFERENCES drivers (driver_username) ON UPDATE CASCADE ON DELETE CASCADE,
	s_location TEXT NOT NULL,
	e_location TEXT NOT NULL,
	s_time TIME NOT NULL,
	e_time TIME NOT NULL,
	s_date DATE NOT NULL,
	e_date DATE NOT NULL,
	license_plate VARCHAR(256) NOT NULL REFERENCES vehicles (license_plate) ON UPDATE CASCADE ON DELETE CASCADE,
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
	
	PRIMARY KEY(driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate)
);
INSERT INTO advertised_trips VALUES('hafiz', 'Pasir Ris', 'Boon Lay', '13:22', '14:22', '17/9/2019', '17/9/2019', 'S1234567J', '3.5', '1.2');
INSERT INTO advertised_trips VALUES('hafiz', 'Jurong', 'Expo', '13:00', '14:22', '18/9/2019', '18/9/2019', 'S1234567J', '2.9', '1.3');
SELECT * FROM advertised_trips;

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
	rating NUMERIC 
	
	--mode_of_acceptance: 'Driver Selected' OR 'System'
	Constraint check_mode_of_acceptance CHECK (mode_of_acceptance = 'Driver Selected' OR mode_of_acceptance = 'System'),
	
	--More than 0
	Constraint check_bid_price CHECK (bid_price > 0),
	
	--Driver cannot bid himself
	Constraint check_driver_username CHECK (driver_username != passenger_username),
	
	FOREIGN KEY (driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate) 
		REFERENCES advertised_trips (driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate),
		
	PRIMARY KEY (passenger_username, driver_username, license_plate, s_time, e_time, s_date, e_date)
);
INSERT INTO bids VALUES('10', 'gervaise', 'hafiz', 'Pasir Ris', 'Boon Lay', '13:22', '14:22', '17/9/2019', '17/9/2019', 'S1234567J', '3.5', '1.2', 'true', 'System', 'true', '3');
INSERT INTO bids VALUES('10', 'gervaise', 'hafiz', 'Jurong', 'Expo', '13:00', '14:22', '18/9/2019', '18/9/2019', 'S1234567J', '2.9', '1.3');
SELECT * FROM BIDS;