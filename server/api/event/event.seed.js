var _ = require('lodash');
var Event = require('./event.model');
var Organization = require('./../organization/organization.model');
var tracer = require('tracer').console({ level: 'info' });
var N_ORGS = 3;

// Create some test organizations for the events.
var createOrganizations = function(callback) {
  var organizationParams = [];
  for (var i=0 ; i < N_ORGS ; ++i) {
    organizationParams.push({
      name: 'Test Organization ' + i,
      about: 'Bacon drumstick doner swine porchetta tri-tip, strip steak capicola ham hock fatback shoulder beef ribs', // http://baconipsum.com
      email: 'info@testorg_:i.org'.replace(/:i/, i),
      phone: '(555)-555-5555',
      contact: 'George Washington',
      url: 'test.organization:i.org'.replace(/:i/, i),
      active: true
    });
  }
  Organization.find().remove(function(err) {
    if (err) { return callback(err); }
    Organization.create(organizationParams, function(err) {
      callback(err, Array.prototype.slice.call(arguments, 1));
    });
  });
};

var createEvents = function(orgs, start, duration, n, incDays, callback) {
  var end = new Date(start + duration * 3600 * 1000);  // add hours from start
  var arEventParams = [];
  var eventParams = {
    provider: 'local',
    name: 'Test Event 1',
    about: 'Cow pancetta bresaola, shankle biltong meatloaf t-bone pork pork chop corned beef strip steak. Filet mignon doner short loin, turkey pork belly chuck beef ribs shoulder.',
    organization: null,
    volunteerSlots: 5,
    n_volunteers: 0,
    start: start,
    end: end,
    active: true
  };

  for (var i=1 ; i < arguments.length ; ++i) {
    var eventParams_copy = _.cloneDeep(eventParams);
    var dayOfMonth = (new Date(eventParams_copy.start)).getDate();
    eventParams_copy.start += i * incDays * 24 * 3600 * 1000;
    eventParams_copy.end = _.clone(eventParams_copy.start)
    eventParams_copy.end += incDays * 24 * 3600 * 1000;
    eventParams_copy.name = 'Test Event ' + i;
    eventParams_copy.about = 'About ' + eventParams_copy.name;
    eventParams_copy.organization = orgs[Math.floor(Math.random() * orgs.length)];
    arEventParams.push(eventParams_copy);
  }

  Event.find().remove(function(err) {
    if (err) {return callback(err);}
    Event.create(arEventParams, function(err) {
      if (err) {return callback(err);}
      var len = arguments.length;
      tracer.info('finished populating ' + n + ' events until ' + arguments[len-1].start);
      callback(null, Array.prototype.slice.call(arguments, 1));
    });
  });
};

// Helper for testing.
module.exports.seedEvents = function(start, duration, n, incDays, callback) {
  tracer.info('seeding Events');
  var async = require('async');
  async.waterfall([
    createOrganizations,
    function(orgs, callback) { createEvents(orgs, start, duration, n, incDays, callback); }
    ], callback);
};
