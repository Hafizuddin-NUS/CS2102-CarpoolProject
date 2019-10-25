const express = require('express');
const router = express.Router();
const sql_query = require('../sql');

const { Pool } = require('pg')
const pool = new Pool({
    connectionString: process.env.DATABASE_URL
});

router.get('/', function (req, res, next) {
    pool.query(sql_query.query.all_advertised_trips, (err, data) => {
		if(err) {
			console.error("Error getting info");
		} else {
			res.render('passenger', { isLoggedin: req.signedCookies.user_id, title: req.signedCookies.user_id, data: data.rows });
		}
	});
});

module.exports = router;