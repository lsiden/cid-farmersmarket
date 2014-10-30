/**
 * Populate DB with sample data on server start
 * to disable, edit config/environment/index.js, and set `seedDB: false`
 */

'use strict';

var Event = require('../api/event/event.model');
var User = require('../api/user/user.model');

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
  Event.create({
    provider: 'local',
    name: 'Test Event 1',
    about: 'About Test Event 1',
    date: new Date(2014, 11, 1, 13, 0, 0, 0),
    duration: 3,
    active: true
  }), function() {
    console.log('finished populating events');
  };
});
