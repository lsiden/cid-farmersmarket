var Event = require('./event.model');
var _ = require('lodash');

// Helper for testing.
module.exports.seedEvents = function(start, duration, n, incDays, fn) {
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
    if (err) return err;
    Organization.create(organizationParams, function(err) {
      if (err) return err;
      var eventParams = {
        provider: 'local',
        name: 'Test Event 1',
        about: 'Cow pancetta bresaola, shankle biltong meatloaf t-bone pork pork chop corned beef strip steak. Filet mignon doner short loin, turkey pork belly chuck beef ribs shoulder.',  // backonipsum.com
        organization: null,
        volunteerSlots: 5,
        volunteers: 0,
        start: start,
        end: end,
        active: true
      };
      var arEventParams = [];

      for (var i=0 ; i < n ; ++i) {
        var eventParams = _.cloneDeep(eventParams);
        var dayOfMonth = (new Date(eventParams.start)).getDate();
        eventParams.start.addDays(incDays);
        eventParams.end.addDays(incDays);
        eventParams.name = 'Test Event ' + i;
        eventParams.about = 'About ' + eventParams.name;
        eventParams.organization = arguments[i+1];
        arEventParams.push(eventParams);
      }

      //console.log(arEventParams);
      Event.create(arEventParams, function(err) {
        if (err) {
          if (fn) return fn(err);
          console.log(err);
          return err;
        }
        var len = arguments.length;
        console.log('finished populating ' + n + ' events until ' + arguments[len-1].start);
        if (fn) fn();
      });
    });
  });
};
