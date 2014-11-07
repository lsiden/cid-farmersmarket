'use strict';

var _ = require('lodash');
var Volunteer = require('./volunteer.model');

// Get list of volunteers
exports.index = function(req, res) {
  Volunteer.find(function (err, volunteers) {
    if(err) { return handleError(res, err); }
    return res.json(200, volunteers);
  });
};

// Get a single volunteer
exports.show = function(req, res) {
  Volunteer.findById(req.params.id, function (err, volunteer) {
    if(err) { return handleError(res, err); }
    if(!volunteer) { return res.send(404); }
    return res.json(volunteer);
  });
};

// Creates a new volunteer in the DB.
exports.create = function(req, res) {
  Volunteer.create(req.body, function(err, volunteer) {
    if(err) { return handleError(res, err); }
    return res.json(201, volunteer);
  });
};

// Creates a new volunteer in the DB if one is not found by email.
// Otherwise updates existing.
exports.findOrCreate = function(req, res) {
  Volunteer.findOneAndUpdate({email: req.body.email}, req.body, { upsert: true }, function(err, volunteer) {
    if(err) { return handleError(res, err); }
    return res.json(201, volunteer);
  });
};

// Updates an existing volunteer in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Volunteer.findById(req.params.id, function (err, volunteer) {
    if (err) { return handleError(res, err); }
    if(!volunteer) { return res.send(404); }
    var updated = _.merge(volunteer, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, volunteer);
    });
  });
};

// Deletes a volunteer from the DB.
exports.destroy = function(req, res) {
  Volunteer.findById(req.params.id, function (err, volunteer) {
    if(err) { return handleError(res, err); }
    if(!volunteer) { return res.send(404); }
    volunteer.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
