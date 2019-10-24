const express = require('express');
const router = express.Router();

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

/* SQL Query */
var sql_query = 'SELECT * FROM users WHERE username =';

router.get('/', function(req, res, next) {
	var get_user_info = sql_query +  "'" + req.signedCookies.user_id + "'";
	pool.query(get_user_info, (err, data) => {
		if(err){
            res.json({
                message : 'ERROR'
            }); 
		}
		else if (data.rows.length == 1) {
			res.render('dashboard', { title: req.signedCookies.user_id , data: data.rows, isLoggedin: req.signedCookies.user_id });
		}
		else {
			next(new Error('Error more than 2 entries found.'));
		}
	});
});

module.exports = router;