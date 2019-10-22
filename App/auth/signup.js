const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

router.get('/', function(req, res, next) {
    res.render('signup', { title: 'Sign Up' });
  });

/* SQL Query */
var sql_query = 'SELECT * FROM users WHERE';
var add_user_query = 'INSERT INTO users VALUES';

router.post('/', (req, res, next) => {
    var check_username_query = sql_query +" username = '" + req.body.username + "' OR email = '"+ req.body.email + "'" +';';
    pool.query(check_username_query, (err, data) => {
        if(err){
            res.json({
                message : 'ERROR'
            }); 
        }
        //unique new username and email 
        else if(data.rows.length == 0) {
            bcrypt.hash(req.body.password, 10).then((hash) => {
                
                //add user to database
                var username = req.body.username;
                var gender = req.body.gender;
                var phone_num = req.body.phone_num;
                var email = req.body.email;
                var display_name = req.body.display_name;

                // Construct Specific SQL Query
                var insert_new_user = add_user_query + "('" + username + "','" + hash + "','" + gender + "','" + phone_num + "','" + email + "','" + display_name + "')";
                pool.query(insert_new_user, (err, data) => {
                    res.json({
                        message : 'User account created!'
                    });
                }); 
            });
        }
        else if(data.rows.length > 0) {
            next(new Error('Username/email already exist.'));
        }
    });
});

module.exports = router;