'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var VolunteerSchema = new Schema({
  name: String,
  email: { type: String, lowercase: true, index: { unique: true } },
  phone: String
});

/**
 * Validations
 */

// Validate empty email
VolunteerSchema
  .path('email')
  .validate(function(email) {
    return email.length;
  }, 'Email cannot be blank');

// Validate email is not taken
VolunteerSchema
  .path('email')
  .validate(function(value, respond) {
    var self = this;
    this.constructor.findOne({email: value}, function(err, user) {
      if(err) throw err;
      if(user) {
        if(self.id === user.id) return respond(true);
        return respond(false);
      }
      respond(true);
    });
}, 'The specified email address is already in use.');

module.exports = mongoose.model('Volunteer', VolunteerSchema);
