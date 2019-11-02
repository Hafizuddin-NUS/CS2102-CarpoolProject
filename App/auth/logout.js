const express = require('express');
const router = express.Router();

router.get('/', function(req, res, next) {
    res.clearCookie('user_id');
    res.redirect('./login');
});

router.post('/', function(req, res, next) {
    res.clearCookie('user_id');
});


module.exports = router;