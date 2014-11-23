'use strict';

var VolunteerEvent = require('../volunteer_event/volunteer_event.model');
var mongoose = require('mongoose'),
    timestamps = require('mongoose-timestamp'),
    Schema = mongoose.Schema,
    _ = require('lodash');
    
require('../organization/organization.model.js');

var EventSchema = new Schema({
  name: String,
  about: String,
  organization: { type: Schema.Types.ObjectId, ref: 'Organization' },
  start: Date,  // includes time
  end: Date,    // includes time

  // Do not enforce volunteers <= volunteerSlots.
  // Allow for people to volunteer as alternates.
  volunteerSlots: Number,
  n_volunteers: Number,

  active: Boolean
});

EventSchema.plugin(timestamps);

EventSchema.methods = {
};

module.exports = mongoose.model('Event', EventSchema);
