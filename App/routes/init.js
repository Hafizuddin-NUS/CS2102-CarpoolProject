const express = require('express');
const sql_query = require('../sql');
const router = express.Router();

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

// POST 
router.post('/update_info', (req, res, next) => {
	var username  = req.body.username;
    var display_name = req.body.display_name;
    var phone_num = req.body.phone_num;
	pool.query(sql_query.query.update_info, [username, display_name, phone_num], (err, data) => {
		if(err) {
			console.error("Error in update info");
		} else {
			res.redirect('/dashboard');
		}
	});
});

module.exports = router;