/**
 * Populate DB with sample data on server start
 * to disable, edit config/environment/index.js, and set `seedDB: false`
 */
 // TODO make sure this doesn't get into production or it will wipe the database.

'use strict';

require('../../common/date')

var Organization = require('../api/organization/organization.model');
var VolunteerEvent = require('../api/volunteer_event/volunteer_event.model');
var Volunteer = require('../api/volunteer/volunteer.model');
var Event = require('../api/event/event.model');
var EventSeed = require('../api/event/event.seed');
var User = require('../api/user/user.model');
var _ = require('lodash');

User.collection.dropAllIndexes(function(err, res) {});
Event.collection.dropAllIndexes(function(err, res) {});
Volunteer.collection.dropAllIndexes(function(err, res) {});
VolunteerEvent.collection.dropAllIndexes(function(err, res) {});
Organization.collection.dropAllIndexes(function(err, res) {});

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
  startDate.setHours(11);
  startDate.setMinutes(0);
  EventSeed.seedEvents(startDate, 4, 12, 7);
});

VolunteerEvent.find({}).remove(function() {
});

Volunteer.find({}).remove(function() {
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
