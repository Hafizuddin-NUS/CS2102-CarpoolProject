const express = require('express');
const router = express.Router();
const sql_query = require('../sql');

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});


router.get('/', function(req, res, next) {
	pool.query(sql_query.query.all_type_cat, (err, data) => {
		if(err){
            res.json({
                message : 'ERROR'
            }); 
		}
		else if (data.rows.length !=0) {
			pool.query(sql_query.query.check_driver,[req.signedCookies.user_id], (err2,data2) =>{
				if(err2){
					res.json({
						message : 'ERROR2'
					}); 
				}
				if (data2.rows.length == 1){
					res.render('driver_update', { title: req.signedCookies.user_id , data: data.rows, isLoggedin: req.signedCookies.user_id, status: "Registered" });
				}
				else{
					res.render('driver_update', { title: req.signedCookies.user_id , data: data.rows, isLoggedin: req.signedCookies.user_id, status: "Not Registered" });
				}
			});
		}
		else {
			next(new Error('Error 0 found'));
		}
	});
});

router.get('/add_vehicle=Car', (req, res, next) => {
    var type  = req.body.type
	pool.query(sql_query.query.get_model,['Car'], (err, data) => {
		if(err) {
			console.error(err);
		} else if(data.rows.length==0){
            next(new Error('Error 0 found'));
        }
        else{
            res.render('add_vehicle', {title: req.signedCookies.user_id , data: data.rows, isLoggedin: req.signedCookies.user_id});
        }
	});
});

router.get('/add_vehicle=Minibus', (req, res, next) => {
    var type  = req.body.type
	pool.query(sql_query.query.get_model,['Minibus'], (err, data) => {
		if(err) {
			console.error(err);
		} else if(data.rows.length==0){
            next(new Error('Error 0 found'));
        }
        else{
            res.render('add_vehicle', {title: req.signedCookies.user_id , data: data.rows, isLoggedin: req.signedCookies.user_id});
        }
	});
});

router.post('/adding_vehicle', (req, res, next) => {
    var license_plate  = req.body.license_plate;
    var model = req.body.model;
	pool.query(sql_query.query.add_vehicle,[license_plate, model] ,(err, data) => {
		if(err) {
			pool.query(sql_query.query.add_to_drives,[req.signedCookies.user_id, license_plate] ,(err2, data2) => {
				if(err2) {
					console.error(err2);
				} 
				else{
					res.redirect('../dashboard');
				}
			});
		} 
        else{
			pool.query(sql_query.query.add_to_drives,[req.signedCookies.user_id, license_plate] ,(err2, data2) => {
				if(err2) {
					console.error(err2);
				} 
				else{
					res.redirect('../dashboard');
				}
			});
        }
	});
});

router.get('/add_driver', (req, res, next) => {
	res.render('driver_add', {title: req.signedCookies.user_id, isLoggedin: req.signedCookies.user_id});

});

router.post('/add_driver', (req, res, next) => {
	pool.query(sql_query.query.add_driver,[req.signedCookies.user_id] ,(err, data) => {
		if(err) {
			console.error(err);
		} 
        else{
            res.redirect('../dashboard');
        }
	});

});

module.exports = router;