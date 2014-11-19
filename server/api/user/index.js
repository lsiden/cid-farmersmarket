'use strict';

var express = require('express');
var controller = require('./user.controller');
var config = require('../../config/environment');
var auth = require('../../auth/auth.service');
var router = express.Router();
var auth = require('../../auth/auth.service');

router.get('/', controller.index);
router.delete('/:id', auth.isAdmin(), controller.destroy);
router.get('/me', auth.isAuthenticated(), controller.me);
router.put('/:id/contactInfo', auth.isAuthenticated(), controller.changeContactInfo);
router.put('/:id/password', auth.isAuthenticated(), controller.changePassword);
router.get('/:id', auth.isAuthenticated(), controller.show);
router.put('/:id', auth.isAdmin(), controller.update);
router.post('/', controller.create);

module.exports = router;
