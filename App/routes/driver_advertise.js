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
	var s_time_parsed = s_time.split(":");
	if (6 < parseInt(s_time_parsed[0]) && parseInt(s_time_parsed[0]) <= 9) {
		var surge = 'Morning Peak';
	} else if (9 < parseInt(s_time_parsed[0]) && parseInt(s_time_parsed[0]) <= 12) {
		var surge = 'Morning';
	} else if (12 < parseInt(s_time_parsed[0]) && parseInt(s_time_parsed[0]) <= 17 ) {
		var surge = 'Afternoon';
	} else if (17 < parseInt(s_time_parsed[0]) && parseInt(s_time_parsed[0]) <= 20 ) {
		var surge = 'Evening';
	} else {
		var surge = 'Night';
	}
	var total_dist = 0;
	var min_bid = 0;
	var driver_rating = '5';
	pool.query(sql_query.query.get_dist,[s_location, e_location],(err,data) => {
		if (err){
			console.error(err);
		} else {
			total_dist = data.rows[0].dist;
			pool.query(sql_query.query.get_min_bid, [s_location, e_location, surge],(err2, data2) => {
				if(err2) {
					console.error(err2);
				}
				else
				{
					min_bid = data2.rows[0].price;
					pool.query(sql_query.query.add_advertised_trips, [driver_username, s_location, e_location, s_time, e_time, s_date, e_date, license_plate, min_bid, total_dist , driver_rating],(err3, data3) => {
						if(err3) {
							console.error(err);
						}
						else
						{
							console.log(parseInt(s_time_parsed[0]), " " + surge);
							res.redirect('/driver_advertise');
						}
					});
				}
			});
		}
	});
});

router.post('/delete_advertise', (req, res, next) => {
	var driver_username  = req.signedCookies.user_id;
    var license_plate = req.body.license_plate;
	var s_time = req.body.s_time;
	var e_time = req.body.e_time;
	var s_date = req.body.s_date;
	var formatted_s_date = moment(s_date,'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	var e_date = req.body.e_date;
	var formatted_e_date = moment(e_date,'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	pool.query(sql_query.query.delete_advertised_trips, [driver_username, s_time, e_time, formatted_s_date, formatted_e_date, license_plate],(err, data2) => {
		if(err) {
			console.error(err);
		}
		else
		{
			res.redirect('/driver_advertise');
		}
	});
});

router.post('/accept_bid', (req, res, next) => {
	var driver_username  = req.signedCookies.user_id;
    var passenger_username = req.body.passenger_username;
    var license_plate = req.body.license_plate;
	var s_time = req.body.s_time;
	var e_time = req.body.e_time;
	var s_date = req.body.s_date;
	var formatted_s_date = moment(s_date,'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	var e_date = req.body.e_date;
	var formatted_e_date = moment(e_date,'ddd MMM DD YYYY hh:mm:ss [GMT]ZZ').format('DD/MM/YYYY');
	pool.query(sql_query.query.accept_bid, [passenger_username, driver_username, s_time, e_time, formatted_s_date, formatted_e_date, license_plate],(err, data2) => {
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
			pool.query(sql_query.query.get_location, (err2, data2) => {
				if(err2){
					console.error(err2);
				}
				else if (data2.rows.length >= 0){
					pool.query(sql_query.query.display_driver_bids, [driver_username], (err3, data3) => {
						if(err3){
							console.error(err3);
						} else{	
							pool.query(sql_query.query.get_license_plate_of_driver, [driver_username], (err4, data4) => {
								if(err4){
									console.error(err4);
								} else{	
									pool.query(sql_query.query.confirmed_bids, [driver_username], (err5, data5) => {
										if(err5){
											console.error(err5);
										} else{	
											pool.query(sql_query.query.driver_completed_trips, [driver_username], (err6, data6) => {
												if(err5){
													console.error(err6);
												} else{	
													res.render('driver_advertise', { title: req.signedCookies.user_id , data: data.rows, data2: data2.rows, data3: data3.rows, data4: data4.rows, data5: data5.rows, data6: data6.rows, isLoggedin: req.signedCookies.user_id });
												}
											});
										}
									});
								}
							});
						}
					});
				}
			});
		}
		else {
			next(new Error('Error more than 2 entries found.'));
		}
	});
});

module.exports = router;