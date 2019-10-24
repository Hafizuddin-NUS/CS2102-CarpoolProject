const express = require('express');
const router = express.Router();

router.get('/', function(req, res, next) {
    res.clearCookie('user_id');
    res.redirect('./login');
});

module.exports = router;