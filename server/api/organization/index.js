'use strict';

var express = require('express');
var controller = require('./organization.controller');
var auth = require('../../auth/auth.service');
var router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.show);
router.post('/', auth.isAdmin(), controller.create);
router.put('/:id', auth.isAdmin(), controller.update);
router.patch('/:id', auth.isAdmin(), controller.update);
router.delete('/:id', auth.isAdmin(), controller.destroy);

module.exports = router;
