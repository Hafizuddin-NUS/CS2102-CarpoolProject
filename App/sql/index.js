const sql = {}

sql.query = {
    // Update
    update_info: "UPDATE users SET display_name=$2, phone_num=$3 WHERE username=$1",
    check_driver: "SELECT * FROM drivers WHERE driver_username=$1",
    all_type_cat: "SELECT * FROM category",
    add_vehicle: "INSERT INTO vehicles VALUES ($1, $2)",
    get_model: "SELECT * FROM category WHERE type=$1",

    add_advertised_trips: "INSERT INTO advertised_trips VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
    driver_advertised_trips: "SELECT * FROM advertised_trips WHERE driver_username = $1",
    all_advertised_trips: "SELECT * FROM advertised_trips",
    add_bid: "INSERT INTO bids VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
    display_bids : "SELECT bid_price, passenger_username, driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, is_win FROM bids WHERE passenger_username= $1"
}

module.exports = sql