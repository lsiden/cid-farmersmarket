'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var OrganizationSchema = new Schema({
  name: String,
  about: String,
  email: String,
  phone: String,
  active: Boolean
});

module.exports = mongoose.model('Organization', OrganizationSchema);
