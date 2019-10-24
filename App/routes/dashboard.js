const express = require('express');
const router = express.Router();

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

/* SQL Query */
var sql_query = 'SELECT * FROM student_info';

router.get('/', function(req, res, next) {
	pool.query(sql_query, (err, data) => {
		res.render('dashboard', { title: req.signedCookies.user_id , data: data.rows, isLoggedin: req.signedCookies.user_id });
	});
});

module.exports = router;