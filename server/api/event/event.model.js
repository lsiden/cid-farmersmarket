'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var time = require('../../components/time');

var EventSchema = new Schema({
  name: String,
  about: String,
  date: Date,  // includes time
  duration: Number, // length of even in hours
  active: Boolean
});

EventSchema.methods = {

  startTime: function() {
    return this.date;
  },

  endTime: function() {
    var date = new Date(this.date);
    date.setHours(this.date.getHours() + this.duration);
    return date;
  }
};

module.exports = mongoose.model('Event', EventSchema);
