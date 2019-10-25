const express = require('express');
const router = express.Router();

const { Pool } = require('pg')
const pool = new Pool({
    connectionString: process.env.DATABASE_URL
});

router.get('/', function (req, res, next) {
    res.render('passenger', { isLoggedin: req.signedCookies.user_id, title: req.signedCookies.user_id });
});

module.exports = router;