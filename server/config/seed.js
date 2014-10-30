/**
 * Populate DB with sample data on server start
 * to disable, edit config/environment/index.js, and set `seedDB: false`
 */

'use strict';

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
  var eventParams = {
    provider: 'local',
    name: 'Test Event 1',
    about: 'About Test Event 1',
    date: new Date(2014, 11, 1, 13, 0, 0, 0),
    duration: 4,
    active: true
  };
  console.log('seeding Events');
  var arEventParams = [];

  for (var i=0 ; i < 10 ; ++i) {
    var eventParams = _.cloneDeep(eventParams);
    var dayOfMonth = eventParams.date.getDate();
    eventParams.date.setDate(dayOfMonth + 7); // a week later
    eventParams.name = 'Test Event ' + i;
    eventParams.about = 'About ' + eventParams.name;
    arEventParams.push(eventParams);
  }
  //console.log(arEventParams);
  Event.create(arEventParams, function(err) {
    if (err) {
      console.log(err);
    } else {
      var len = arguments.length;
      console.log('finished populating ' + (len-1) + ' events until ' + arguments[len-1].date);
    }
  });
});
