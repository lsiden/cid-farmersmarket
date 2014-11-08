'use strict';

var mongoose = require('mongoose'),
    timestamps = require('mongoose-timestamp'),
    Schema = mongoose.Schema;

var VolunteerEventSchema = new Schema({
  volunteer_id: { type: Schema.Types.ObjectId, ref: 'Volunteer', index: true },
  event_id: { type: Schema.Types.ObjectId, ref: 'Event', index: true },
  attended: Boolean
});

VolunteerEventSchema.index({ volunteer_id: 1, event_id: 1 }, { unique: true });
VolunteerEventSchema.plugin(timestamps);

module.exports = mongoose.model('VolunteerEvent', VolunteerEventSchema);
