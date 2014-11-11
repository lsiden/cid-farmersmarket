'use strict';

var mongoose = require('mongoose'),
    timestamps = require('mongoose-timestamp'),
    Schema = mongoose.Schema;

var VolunteerEventSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', index: true },
  event: { type: Schema.Types.ObjectId, ref: 'Event', index: true },
  attended: Boolean
});

VolunteerEventSchema.index({ volunteer: 1, event: 1 }, { unique: true });
VolunteerEventSchema.plugin(timestamps);

module.exports = mongoose.model('VolunteerEvent', VolunteerEventSchema);
