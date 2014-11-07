'use strict';

var mongoose = require('mongoose'),
    timestamps = require('mongoose-timestamp'),
    Schema = mongoose.Schema;

var VolunteerEventSchema = new Schema({
  volunteer_id: { type: Schema.Types.ObjectId, index: { unique: true }},
  event_id: { type: Schema.Types.ObjectId, index: { unique: true }},
  created_at: Date, // date that volunteer registered
  attended: Boolean
});

VolunteerEventSchema.plugin(timestamps);

module.exports = mongoose.model('VolunteerEvent', VolunteerEventSchema);
