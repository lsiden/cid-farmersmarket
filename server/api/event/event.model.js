'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var time = require('../../components/time');

var EventSchema = new Schema({
  name: String,
  about: String,
  date: Date,
  startTimeMin: Number, // number of minutes since midnight
  endTimeMin: Number, // number of minutes since midnight
  active: Boolean
});

EventSchema.virtual('startTime').get(function() {
  return time.timeFromMin(this.startTimeMin);
}).set(function(sTime) {
  this.startTimeMin = time.minFromTime(sTime);
});

EventSchema.virtual('endTime').get(function() {
  return time.timeFromMin(this.endTimeMin);
}).set(function(sTime) {
  this.endTimeMin = time.minFromTime(sTime);
});

module.exports = mongoose.model('Event', EventSchema);
