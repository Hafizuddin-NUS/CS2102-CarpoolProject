const sql = {}

sql.query = {
    // Update
    update_info: "UPDATE users SET display_name=$2, phone_num=$3 WHERE username=$1",
    check_driver: "SELECT * FROM drivers WHERE driver_username=$1",
    all_type_cat: "SELECT * FROM category",
    add_vehicle: "INSERT INTO vehicles VALUES ($1, $2)",
    get_model: "SELECT * FROM category WHERE type=$1",
    get_location: "SELECT location FROM location_dist",

    add_advertised_trips: "INSERT INTO advertised_trips VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
    driver_advertised_trips: "SELECT * FROM advertised_trips WHERE driver_username = $1",
    all_advertised_trips: "SELECT * FROM advertised_trips",
    delete_advertised_trips: "DELETE FROM advertised_trips WHERE driver_username = $1 AND s_time = $2 AND e_time = $3 AND s_date = $4 AND e_date = $5 AND license_plate = $6",
    display_driver_bids : "SELECT * FROM Bids Bi WHERE driver_username = $1 AND NOT EXISTS ( SELECT 1 FROM Bids B JOIN (SELECT driver_username, s_time, e_time, s_date, e_date FROM bids WHERE is_win = true) AS A ON B.driver_username = A.driver_username AND B.s_time = A.s_time AND B.e_time = A.e_time AND B.s_date = A.s_date AND B.e_date = A.e_date WHERE Bi.driver_username = B.driver_username AND Bi.s_time = B.s_time AND Bi.e_time = B.e_time AND Bi.s_date = B.s_date AND Bi.e_date = B.e_date)",
    accept_bid: "UPDATE bids SET is_win='t' WHERE passenger_username = $1 AND driver_username = $2 AND s_time = $3 AND e_time = $4 AND s_date = $5 AND e_date = $6 AND license_plate = $7 AND is_win = false",
    add_bid: "INSERT INTO bids VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
    display_bids : "SELECT bid_price, passenger_username, driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, is_win FROM bids WHERE passenger_username= $1"
    delete_bid: "DELETE FROM bids WHERE passenger_username = $1 AND driver_username = $2 AND s_time = $3 AND e_time = $4 AND s_date = $5 AND e_date = $6 AND license_plate = $7 AND is_win = false",
    end_trip: "UPDATE bids SET is_completed='t' , rating=$8 WHERE passenger_username = $1 AND driver_username = $2 AND s_time = $3 AND e_time = $4 AND s_date = $5 AND e_date = $6 AND license_plate = $7 AND is_win = true",
    filter_advertised_trips: "SELECT * FROM advertised_trips WHERE s_location = $1"
}

module.exports = sql