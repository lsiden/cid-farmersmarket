var _ = require('lodash');
var Event = require('./event.model');

// Helper for testing.
module.exports.seedEvents = function(start, duration, n, incDays, callback) {
  console.log('seeding Events');
  var Organization = require('./../organization/organization.model');
  var end = _.cloneDeep(start).addHours(duration);

  // Create some test organizations for the events.
  var organizationParams = [];
  for (var i=0 ; i < n ; ++i) {
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
    if (err) return callback(err);
    Organization.create(organizationParams, function(err) {
      if (err) return callback(err);
      var eventParams = {
        provider: 'local',
        name: 'Test Event 1',
        about: 'Cow pancetta bresaola, shankle biltong meatloaf t-bone pork pork chop corned beef strip steak. Filet mignon doner short loin, turkey pork belly chuck beef ribs shoulder.',  // backonipsum.com
        organization: null,
        volunteerSlots: 5,
        n_volunteers: 0,
        start: start,
        end: end,
        active: true
      };
      var arEventParams = [];

      for (var i=1 ; i < arguments.length ; ++i) {
        var eventParams_copy = _.cloneDeep(eventParams);
        var dayOfMonth = (new Date(eventParams_copy.start)).getDate();
        eventParams_copy.start.addDays(incDays);
        eventParams_copy.end.addDays(incDays);
        eventParams_copy.name = 'Test Event ' + i;
        eventParams_copy.about = 'About ' + eventParams_copy.name;
        eventParams_copy.organization = arguments[i];
        arEventParams.push(eventParams_copy);
      }

      //console.log(arEventParams);
      Event.create(arEventParams, function(err) {
        if (err) return callback(err);
        var len = arguments.length;
        console.log('finished populating ' + n + ' events until ' + arguments[len-1].start);
        var events = [];
        for (var i=1 ; i < arguments.length ; ++i) {
          events.push(arguments[i]);
        }
        return callback(null, events);
      });
    });
  });
};
