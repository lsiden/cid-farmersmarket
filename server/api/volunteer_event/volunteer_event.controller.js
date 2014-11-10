'use strict';

var _ = require('lodash');
var VolunteerEvent = require('./volunteer_event.model');
var Volunteer = require('../volunteer/volunteer.model');
var Event = require('../event/event.model');
var Organization = require('../organization/organization.model');

// Get list of volunteer_events
exports.index = function(req, res) {
  // console.log(req.query);
  VolunteerEvent.find(req.query)
  .populate({path: 'volunteer', model: Volunteer })
  .populate({path: 'event', model: Event })
  .populate({path: 'event.organization', model: Organization })
  .exec(function (err, volunteer_events) {
    if(err) { return handleError(res, err); }
    return res.json(200, volunteer_events);
  });
};

// Get a single volunteer_event
exports.show = function(req, res) {
  VolunteerEvent.findById(req.params.id)
  .populate({path: 'volunteer', model: Volunteer })
  .populate({path: 'event', model: Event })
  .populate({path: 'event.organization', model: Organization })
  .exec(function (err, volunteer_event) {
    if(err) { return handleError(res, err); }
    return res.json(volunteer_event);
  });
};

// Creates a new volunteer_event in the DB if one does not already exist.
exports.create = function(req, res) {
  VolunteerEvent.findOne(req.body, function(err, volunteer_event) {
    if(err) { return handleError(res, err); }
    if (volunteer_event) { return res.json(201, volunteer_event); }
    // console.log(req.body);
    VolunteerEvent.create(req.body, function(err, volunteer_event) {
      if(err) { return handleError(res, err); }
      return res.json(201, volunteer_event);
    });
  });
};

// Updates an existing volunteer_event in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  VolunteerEvent.findById(req.params.id, function (err, volunteer_event) {
    if (err) { return handleError(res, err); }
    if(!volunteer_event) { return res.send(404); }
    var updated = _.merge(volunteer_event, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, volunteer_event);
    });
  });
};

// Deletes a volunteer_event from the DB.
exports.destroy = function(req, res) {
  VolunteerEvent.findById(req.params.id, function (err, volunteer_event) {
    if(err) { return handleError(res, err); }
    if(!volunteer_event) { return res.send(404); }
    volunteer_event.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
