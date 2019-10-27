const express = require('express');
const router = express.Router();
const sql_query = require('../sql');

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

router.get('/', (req, res, next) => {
  //var type  = req.body.type;
pool.query(sql_query.query.get_model, ['car'], (err, data) => {
  if(err) {
    console.error(err);
  } else if(data.rows.length==0){
          console.error("Error");
      }
      else{
          res.render('add_vehicle', {title: req.signedCookies.user_id , data: data.rows, isLoggedin: req.signedCookies.user_id});
      }
});
});
module.exports = router;
