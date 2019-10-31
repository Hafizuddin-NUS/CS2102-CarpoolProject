const sql = {}

sql.query = {
    // Update
    update_info: "UPDATE users SET display_name=$2, phone_num=$3 WHERE username=$1",
    check_driver: "SELECT * FROM drivers WHERE driver_username=$1",
    all_type_cat: "SELECT * FROM category",
    add_vehicle: "INSERT INTO vehicles VALUES ($1, $2)",
    get_model: "SELECT * FROM category WHERE type=$1",
    get_location: "SELECT location FROM location_dist",
    add_driver: "INSERT INTO drivers VALUES($1) ",

    add_advertised_trips: "INSERT INTO advertised_trips VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
    driver_advertised_trips: "SELECT * FROM advertised_trips WHERE driver_username = $1",
    all_advertised_trips: "SELECT * FROM advertised_trips",
    delete_advertised_trips: "DELETE FROM advertised_trips WHERE driver_username = $1 AND s_time = $2 AND e_time = $3 AND s_date = $4 AND e_date = $5 AND license_plate = $6",
    add_bid: "INSERT INTO bids VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
    delete_bid: "DELETE FROM bids WHERE passenger_username = $1 AND driver_username = $2 AND s_time = $3 AND e_time = $4 AND s_date = $5 AND e_date = $6 AND license_plate = $7 AND is_win = false",
    end_trip: "UPDATE bids SET is_completed='t' , rating=$8 WHERE passenger_username = $1 AND driver_username = $2 AND s_time = $3 AND e_time = $4 AND s_date = $5 AND e_date = $6 AND license_plate = $7 AND is_win = true",
    display_bids : "SELECT bid_price, passenger_username, driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, is_win FROM bids WHERE passenger_username= $1 AND is_completed=$2"
}

module.exports = sql