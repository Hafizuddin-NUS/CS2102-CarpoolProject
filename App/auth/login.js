const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

router.get('/', function(req, res, next) {
    res.render('auth_login', { title: 'Login' });
  });


/* SQL Query */
var sql_query = 'SELECT * FROM users WHERE';
var add_user_query = 'INSERT INTO users VALUES';

router.post('/', (req, res, next) => {
    var check_username_query = sql_query +" username = '" + req.body.username + "';";
    pool.query(check_username_query, (err, data) => {
        if(err){
            res.json({
                message : 'ERROR'
            }); 
        }
        //username found
        else if(data.rows.length == 1) {
            //compare password if they are valid
            bcrypt.compare(req.body.password, data.rows[0].password)
            .then((result) => {
                if (result) {
                    //setting the set-cookie header
                    const isSecure = req.app.get('env') != 'development';
                    res.cookie('user_id', data.rows[0].username, {
                        httpOnly: true,
                        secure: isSecure,
                        signed: true
                    });
                    res.json({
                        id : data.rows[0].username,
                        message : 'Logged in!'
                    }); 
                } else {
                    next(new Error('Invalid user'));
                }
            });
        }
        else {
            next(new Error('Invalid login'));
        }
    });
});

module.exports = router;