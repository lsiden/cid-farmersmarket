'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var time = require('../../components/time');
var _ = require('lodash');

var EventSchema = new Schema({
  name: String,
  about: String,
  start: Date,  // includes time
  end: Date,    // includes time
  active: Boolean
});

EventSchema.methods = {
};

module.exports = mongoose.model('Event', EventSchema);

module.exports.seedEvents = function(start, duration, n, incDays, fn) {
  console.log('seeding Events');
  var end = _.cloneDeep(start).addHours(duration);

  var eventParams = {
    provider: 'local',
    name: 'Test Event 1',
    about: 'About Test Event 1',
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
    arEventParams.push(eventParams);
  }

  //console.log(arEventParams);
  var Event = mongoose.model('Event', EventSchema);
  Event.create(arEventParams, function(err) {
    if (err) {
      if (fn) return fn(err);
      console.log(err);
      return err;
    }
    var len = arguments.length;
    console.log('finished populating ' + (len-1) + ' events until ' + arguments[len-1].start);
    if (fn) fn();
  });
};
