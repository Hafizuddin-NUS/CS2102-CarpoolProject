const sql = {}

sql.query = {

    update_info: "UPDATE users SET display_name=$2, phone_num=$3 WHERE username=$1",
    check_driver: "SELECT * FROM drivers WHERE driver_username=$1",
    driver_rating: "SELECT driver_username, round(avg(rating), 2) as driver_rating FROM bids WHERE driver_username = $1 GROUP BY driver_username",
    all_type_cat: "SELECT DISTINCT type FROM category",
    add_vehicle: "INSERT INTO vehicles VALUES ($1, $2)",
    get_model: "SELECT * FROM category WHERE type=$1",
    get_location: "SELECT location FROM location_dist",
    add_driver: "INSERT INTO drivers VALUES($1) ",
    get_license_plate_of_driver: "SELECT license_plate FROM drives WHERE driver_username=$1",
    get_user_info: "SELECT * , get_membership(A.username) FROM users A WHERE username = $1",
    get_membership: "SELECT get_membership($1)",
    delete_car: "DELETE FROM drives WHERE driver_username=$1 AND license_plate=$2",
    get_seats_offered: "SELECT C.license_plate, D.seats_offered FROM (vehicles A NATURAL JOIN drives B) AS C NATURAL JOIN category D WHERE driver_username=$1",
    get_dist: "SELECT ABS(A.metrics - B.metrics) AS dist FROM location_dist A, location_dist B WHERE A.location=$1 AND B.location=$2",
    get_min_bid: "SELECT (surge_rate*FinalLocation) AS price FROM (SELECT (SELECT get_price(ABS(A.locationA - A.locationB))) AS FinalLocation FROM (SELECT A.metrics AS locationA, B.metrics AS locationB FROM location_dist A, location_dist B WHERE A.location=$1 AND B.location=$2) AS A) AS B NATURAL JOIN (SELECT surge_rate FROM surge WHERE time=$3) AS C",
    add_advertised_trips: "INSERT INTO advertised_trips VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
    driver_advertised_trips: "SELECT a.* FROM advertised_trips a WHERE driver_username = $1 AND NOT EXISTS ( SELECT 1 FROM bids b WHERE a.driver_username = b.driver_username AND a.s_time = b.s_time AND a.e_time = b.e_time AND a.s_date = b.s_date AND a.e_date = b.e_date AND a.license_plate = b.license_plate AND (b.is_completed = true OR b.is_win = true));",
    all_advertised_trips: "SELECT DISTINCT A.driver_username, A.s_time, A.e_time, A.s_date, A.e_date, A.license_plate, A.s_location, A.e_location, A.min_bid FROM advertised_trips A WHERE NOT A.driver_username=$1 EXCEPT SELECT DISTINCT B.driver_username, B.s_time, B.e_time, B.s_date, B.e_date, B.license_plate, B.s_location, B.e_location, B.min_bid FROM bids B WHERE (B.is_win='t') OR (B.passenger_username=$1 AND B.is_win='f')",
    add_to_drives: "INSERT INTO drives VALUES($1,$2)",
    delete_advertised_trips: "DELETE FROM advertised_trips WHERE driver_username = $1 AND s_time = $2 AND e_time = $3 AND s_date = $4 AND e_date = $5 AND license_plate = $6",
    display_driver_bids: "SELECT * FROM bids Bi WHERE driver_username = $1 AND NOT EXISTS ( SELECT 1 FROM bids B JOIN (SELECT driver_username, s_time, e_time, s_date, e_date FROM bids WHERE is_win = true) AS A ON B.driver_username = A.driver_username AND B.s_time = A.s_time AND B.e_time = A.e_time AND B.s_date = A.s_date AND B.e_date = A.e_date WHERE Bi.driver_username = B.driver_username AND Bi.s_time = B.s_time AND Bi.e_time = B.e_time AND Bi.s_date = B.s_date AND Bi.e_date = B.e_date)",
    accept_bid: "UPDATE bids SET is_win='t', mode_of_acceptance = 'Driver Selected' WHERE passenger_username = $1 AND driver_username = $2 AND s_time = $3 AND e_time = $4 AND s_date = $5 AND e_date = $6 AND license_plate = $7 AND is_win = false",
    confirmed_bids: "SELECT * FROM bids WHERE driver_username = $1 AND is_win = true AND is_completed = false",
    driver_completed_trips: "SELECT * FROM bids WHERE driver_username = $1 AND is_completed = true",
    display_driver_bids2: "SELECT * FROM bids Bi WHERE driver_username = $1 AND s_location = $2 AND e_location = $3 AND s_date = $4 AND NOT EXISTS ( SELECT 1 FROM bids B JOIN (SELECT driver_username, s_time, e_time, s_date, e_date FROM bids WHERE is_win = true) AS A ON B.driver_username = A.driver_username AND B.s_time = A.s_time AND B.e_time = A.e_time AND B.s_date = A.s_date AND B.e_date = A.e_date WHERE Bi.driver_username = B.driver_username AND Bi.s_time = B.s_time AND Bi.e_time = B.e_time AND Bi.s_date = B.s_date AND Bi.e_date = B.e_date)",
    add_bid: "INSERT INTO bids VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
    display_bids: "SELECT * FROM bids A WHERE A.passenger_username = $1 EXCEPT (SELECT DISTINCT B.* FROM bids B, bids C WHERE (B.driver_username = C.driver_username AND B.s_time = C.s_time AND B.e_time = C.e_time AND B.s_date = C.s_date AND B.e_date = C.e_date AND B.license_plate = C.license_plate AND B.is_win='f' AND C.is_win='t') UNION SELECT * FROM bids D WHERE D.is_completed='t')",
    display_bids_completed: "SELECT bid_price, passenger_username, driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, is_win FROM bids WHERE passenger_username= $1 AND is_completed='t'",
    delete_bid: "DELETE FROM bids WHERE passenger_username = $1 AND driver_username = $2 AND s_time = $3 AND e_time = $4 AND s_date = $5 AND e_date = $6 AND license_plate = $7 AND is_win = false",
    end_trip: "UPDATE bids SET is_completed='t' , rating=$8 WHERE passenger_username = $1 AND driver_username = $2 AND s_time = $3 AND e_time = $4 AND s_date = $5 AND e_date = $6 AND license_plate = $7 AND is_win = true",
    filter_advertised_trips: "SELECT DISTINCT A.driver_username, A.s_time, A.e_time, A.s_date, A.e_date, A.license_plate, A.s_location, A.e_location, A.min_bid FROM advertised_trips A WHERE NOT A.driver_username=$1 AND s_location=$2 AND e_location=$3 AND s_date=$4 EXCEPT SELECT DISTINCT B.driver_username, B.s_time, B.e_time, B.s_date, B.e_date, B.license_plate, B.s_location, B.e_location, B.min_bid FROM bids B WHERE (B.is_win='t') OR (B.passenger_username=$1 AND B.is_win='f')",
    //trigger
    delete_users: "DELETE FROM users WHERE username = $1"
}

module.exports = sql