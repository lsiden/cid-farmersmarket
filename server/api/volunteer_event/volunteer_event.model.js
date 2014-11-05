'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var VolunteerEventSchema = new Schema({
  volunteer: Schema.Types.ObjectId,
  event: Schema.Types.ObjectId,
  attended: Boolean
});

module.exports = mongoose.model('VolunteerEvent', VolunteerEventSchema);
