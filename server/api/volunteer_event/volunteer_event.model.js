'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var VolunteerEventSchema = new Schema({
  volunteer_id: { type: Schema.Types.ObjectId, index: { unique: true }},
  event_id: { type: Schema.Types.ObjectId, index: { unique: true }},
  created_at: Date, // date that volunteer registered
  attended: Boolean
});

// http://stackoverflow.com/a/12670523/270511
VolunteerEventSchema.pre('save', function(next) {
  if (!this.created_at) {
    this.created_at = new Date();
  }
  next();
});

module.exports = mongoose.model('VolunteerEvent', VolunteerEventSchema);
