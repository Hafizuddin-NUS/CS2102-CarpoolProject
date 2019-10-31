const express = require('express');
const router = express.Router();
const sql_query = require('../sql');
var moment = require('moment');

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

router.get('/', function (req, res, next) {
	var location = req.query.location;
	if (location == null) {
		pool.query(sql_query.query.all_advertised_trips, (err, data) => {
			if (err) {
				console.error("Error getting info");
			} else {
				pool.query(sql_query.query.display_bids, [req.signedCookies.user_id], (err2, data2) => {
					if (err2) {
						console.error("Error getting info");
					} else {
						res.render('passenger', { isLoggedin: req.signedCookies.user_id, title: req.signedCookies.user_id, data: data.rows, data2: data2.rows });
					}
				});
			}
		});
	}
	else {
		pool.query(sql_query.query.filter_advertised_trips, [location], (err, data) => {
			if (err) {
				console.error("Error getting info");
			} else {
				pool.query(sql_query.query.display_bids, [req.signedCookies.user_id], (err2, data2) => {
					if (err2) {
						console.error("Error getting info");
					} else {
						res.render('passenger', { isLoggedin: req.signedCookies.user_id, title: req.signedCookies.user_id, data: data.rows, data2: data2.rows });
					}
				});
			}
		});
	}
});

router.post('/add', (req, res, next) => {
	var driver_username = req.body.driver_username;
	var license_plate = req.body.license_plate;
	var s_location = req.body.s_location;
	var e_location = req.body.e_location;
	var s_time = req.body.s_time;
	var e_time = req.body.e_time;
	var s_date = req.body.s_date;
	var formatted_s_date = moment(s_date, 'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	var e_date = req.body.e_date;
	var formatted_e_date = moment(e_date, 'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	var min_bid = req.body.min_bid;
	var bid_price = req.body.bid_price;
	pool.query(sql_query.query.add_bid, [bid_price, req.signedCookies.user_id, driver_username, s_location, e_location, s_time, e_time, formatted_s_date, formatted_e_date, license_plate, min_bid, "1.2"], (err, data) => {
		if (err) {
			console.error(err);
		}
		else {
			res.redirect('./');
		}
	});
});

router.post('/delete_bid', (req, res, next) => {
	var passenger_username = req.signedCookies.user_id;
	var driver_username = req.body.driver_username;
	var s_time = req.body.s_time;
	var e_time = req.body.e_time;
	var s_date = req.body.s_date;
	var formatted_s_date = moment(s_date, 'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	var e_date = req.body.e_date;
	var formatted_e_date = moment(e_date, 'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	var license_plate = req.body.license_plate;
	pool.query(sql_query.query.delete_bid, [passenger_username, driver_username, s_time, e_time, formatted_s_date, formatted_e_date, license_plate], (err, data2) => {
		if (err) {
			console.error(err);
		}
		else {
			res.redirect('/driver_advertise');
		}
	});
});
router.post('/end_trip', (req, res, next) => {
	var passenger_username = req.signedCookies.user_id;
	var driver_username = req.body.driver_username;
	var s_time = req.body.s_time;
	var e_time = req.body.e_time;
	var s_date = req.body.s_date;
	var formatted_s_date = moment(s_date, 'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	var e_date = req.body.e_date;
	var formatted_e_date = moment(e_date, 'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	var license_plate = req.body.license_plate;
	var rating = req.body.rating;
	pool.query(sql_query.query.end_trip, [passenger_username, driver_username, s_time, e_time, formatted_s_date, formatted_e_date, license_plate, rating], (err, data2) => {
		if (err) {
			console.error(err);
		}
		else {
			res.redirect('/driver_advertise');
		}
	});
});

module.exports = router;
//query = sql_query.query.add_bid + "'" + bid_price + "'," + "'" + req.signedCookies.user_id + "'," + "'" + driver_username + "'," + "'" + s_location + "'," + "'" + e_location 
//	+ "',"+ "'" + "13:00" + "',"+ "'" + "14:22" + "',"+ "'" + "23/09/2019" + "',"+ "'" + "23/09/2019" + "',"+ "'" + license_plate+ "',"+ "'" + min_bid + "',"+ "'1.3')"