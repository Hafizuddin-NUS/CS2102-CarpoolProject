const express = require('express');
const router = express.Router();
const sql_query = require('../sql');
var moment = require('moment');

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

/* POST */
router.post('/advertise', (req, res, next) => {
	var driver_username  = req.signedCookies.user_id;
    var license_plate = req.body.license_plate;
	var s_location = req.body.s_location;
	var e_location = req.body.e_location;
	var s_time = req.body.s_time;
	var e_time = req.body.e_time;
	var s_date = req.body.s_date;
	var e_date = req.body.e_date;
	var min_bid = '5';
	var total_dist = '10';
	var driver_rating = '5';
	pool.query(sql_query.query.add_advertised_trips, [driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, total_dist, driver_rating],(err, data2) => {
		if(err) {
			console.error(err);
		}
		else
		{
			res.redirect('/driver_advertise');
		}
	});
});

/* GET */
router.get('/', function(req, res, next) {
	var driver_username = req.signedCookies.user_id;
	pool.query(sql_query.query.driver_advertised_trips, [driver_username], (err, data) => {
		if(err){
            res.json({
                message : 'ERROR'
            }); 
		}
		else if (data.rows.length >= 0) {
			res.render('driver_advertise', { title: req.signedCookies.user_id , data: data.rows, isLoggedin: req.signedCookies.user_id });
		}
		else {
			next(new Error('Error more than 2 entries found.'));
		}
	});
});

module.exports = router;