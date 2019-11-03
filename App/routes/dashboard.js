const express = require('express');
const router = express.Router();
const sql_query = require('../sql');

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});


router.get('/', function (req, res, next) {
	pool.query(sql_query.query.get_user_info, [req.signedCookies.user_id], (err, data) => {
		if (err) {
			res.json({
				message: 'ERROR'
			});
		}
		else if (data.rows.length == 1) {
			pool.query(sql_query.query.check_driver, [req.signedCookies.user_id], (err2, data2) => {
				if (err2) {
					res.json({
						message: 'ERROR2'
					});
				}
				if (data2.rows.length == 1){
					pool.query(sql_query.query.driver_rating,[req.signedCookies.user_id], (err3,data3) =>{
						if(err3){
							res.json({
								message : 'ERROR3'
							});
						}
						if(data3.rows.length == 1){
								res.render('dashboard', { title: req.signedCookies.user_id , data: data.rows, data3: data3.rows[0].driver_rating, isLoggedin: req.signedCookies.user_id, status: "Registered" });
							}
						else {
							data3.rows[0] = { driver_username: req.signedCookies.user_id , driver_rating: "No Rating" };
							res.render('dashboard', { title: req.signedCookies.user_id , data: data.rows, data3: data3.rows[0].driver_rating, isLoggedin: req.signedCookies.user_id, status: "Registered" });
						}
						});
					}
				else{
					res.render('dashboard', { title: req.signedCookies.user_id , data: data.rows, data3: "No Rating", isLoggedin: req.signedCookies.user_id, status: "Not Registered" });
				}
			});
		}
		else {
			next(new Error('Error more than 2 entries found.'));
		}
	});
});


router.post('/delete_users', (req, res, next) => {
	var username = req.signedCookies.user_id;
	pool.query(sql_query.query.delete_users, [username], function (err, data2) {
		if (err) {
			//console.error(err);
			next(new Error(err));
		}
		else if(data2.rowCount== 0) {
			doA().then(function(msg_from_database) {
				res.json({	
					message: 'Unable to delete user',
					trggier_msg: msg_from_database
				});
			});
		}
		else{
			res.json({	
				message: 'Successfully deleted user',
				rows_deleted: data2.rowCount
			});
		}
	});
});


//Running ASYNC functions in SYNC way
//I promise that database will return a result, if my async notification returns result, resolve it.
function doA() {
	return new Promise(function(resolve,reject) {
		// Connect to Postgres 
		pool.connect( function(err, client) {
			if(err) {
			  console.log(err);
			  reject(err);
			}
		  
			// Listen for all pg_notify channel messages
			client.on('notification', function(msg) {
				//console.log(msg);	//trigger message will be inside this JSON.	
				resolve(msg);
			});
			
			// Designate which channels we are listening on. Add additional channels with multiple lines.
			client.query('LISTEN trigger_error_channel');	//Listen to this channel called 'trigger_error_channel'.
		});
	})
}


module.exports = router;