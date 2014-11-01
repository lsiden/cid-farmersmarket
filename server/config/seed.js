/**
 * Populate DB with sample data on server start
 * to disable, edit config/environment/index.js, and set `seedDB: false`
 */

'use strict';

require('../../../common/date')

var Event = require('../api/event/event.model');
var User = require('../api/user/user.model');
var _ = require('lodash');

User.find({}).remove(function() {
  User.create({
    provider: 'local',
    name: 'Test User',
    email: 'test@test.com',
    password: 'test'
  }, {
    provider: 'local',
    role: 'admin',
    name: 'Admin',
    email: 'admin@admin.com',
    password: 'admin'
  }, function() {
      console.log('finished populating users');
    }
  );
});

Event.find({}).remove(function() {
  var startDate = (new Date()).addDays(-30);
  Event.seedEvents(startDate, 4, 12, 7);
});
