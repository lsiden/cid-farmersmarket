/**
 * Populate DB with sample data on server start
 * to disable, edit config/environment/index.js, and set `seedDB: false`
 */
 // TODO make sure this doesn't get into production or it will wipe the database.

'use strict';

var Organization = require('../api/organization/organization.model');
var VolunteerEvent = require('../api/volunteer_event/volunteer_event.model');
var Event = require('../api/event/event.model');
var EventSeed = require('../api/event/event.seed');
var User = require('../api/user/user.model');
var _ = require('lodash');

User.collection.dropAllIndexes(function(err, res) {});
Event.collection.dropAllIndexes(function(err, res) {});
VolunteerEvent.collection.dropAllIndexes(function(err, res) {});
Organization.collection.dropAllIndexes(function(err, res) {});

User.find({}).remove(function() {
  User.create([{
    provider: 'local',
    role: 'user',
    name: 'Test User',
    email: 'test@test.com',
    phone: '555-555-5555',
    active: true,
    password: 'test'
  }, {
    provider: 'local',
    role: 'user',
    name: 'Test User 2',
    email: 'test2@test.com',
    phone: '555-555-5555',
    active: true,
    password: 'test'
  }, {
    provider: 'local',
    role: 'admin',
    name: 'Admin',
    email: 'admin@admin.com',
    phone: '555-555-5555',
    active: true,
    password: 'admin'
  }], function() {
      console.log('finished populating users');
    }
  );
});

var startDate = new Date()
startDate.setHours(11);
startDate.setMinutes(0);
startDate -= 30 * 24 * 3600 * 1000; // 30 days ago
EventSeed.seedEvents(startDate, 4, 12, 7, function() {});

VolunteerEvent.find({}).remove(function() {
});

/*
Organization.find({}).remove(function() {
  var params = [];
  for (var i=0 ; i < 10 ; ++i) {
    params.push({
      provider: 'local',
      name: 'Test Organization ' + i,
      email: 'info@organization:i.org'.replace(/:i/, i),
      phone: '(555)-555-5555',
      active: true
    });
  }
  Organization.create(params);
});
*/
