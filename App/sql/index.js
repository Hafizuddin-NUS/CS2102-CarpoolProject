const sql = {}

sql.query = {
    // Update
    update_info: "UPDATE users SET display_name=$2, phone_num=$3 WHERE username=$1",

    all_advertised_trips: "SELECT * FROM advertised_trips"
}

module.exports = sql