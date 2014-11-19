'use strict';

var _ = require('lodash');
var helpers = require('../helpers.service');
var VolunteerEvent = require('./volunteer_event.model');
var User = require('../user/user.model');
var Event = require('../event/event.model');
var Organization = require('../organization/organization.model');

// Get list of volunteer_events
exports.index = function(req, res) {
  // console.log(req.query);
  VolunteerEvent.find(req.query)
  .populate({path: 'volunteer', model: User })
  .populate({path: 'event', model: Event })
  .populate({path: 'event.organization', model: Organization })
  .exec(function (err, volunteer_events) {
    if(err) { return helpers.handleError(res, err); }
    return res.json(200, volunteer_events);
  });
};

// Get a single volunteer_event
exports.show = function(req, res) {
  VolunteerEvent.findById(req.params.id)
  .populate({path: 'volunteer', model: User })
  .populate({path: 'event', model: Event })
  .populate({path: 'event.organization', model: Organization })
  .exec(function (err, volunteer_event) {
    if(err) { return helpers.handleError(res, err); }
    return res.json(volunteer_event);
  });
};

// Creates a new volunteer_event in the DB if one does not already exist.
exports.create = function(req, res) {
  VolunteerEvent.findOne(req.body, function(err, volunteer_event) {
    if(err) { return helpers.handleError(res, err); }
    if (volunteer_event) { return res.json(201, volunteer_event); }
    // console.log(req.body);
    VolunteerEvent.create(req.body, function(err, volunteer_event) {
      if(err) { return helpers.handleError(res, err); }
      // console.log(volunteer_event);
      Event.update( { _id: volunteer_event.event}, { $inc: { n_volunteers: 1} }, function(err, num_affected, raw) {
        // console.log(err);
        // console.log(num_affected);
        // console.log(raw);
        if(err) { return helpers.handleError(res, err); }
      });
      return res.json(201, volunteer_event);
    });
  });
};

// Updates an existing volunteer_event in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  if(req.body.volunteer) { delete req.body.volunteer; }
  if(req.body.event) { delete req.body.event; }
  console.log(req.body);
  VolunteerEvent.findById(req.params.id, function (err, volunteer_event) {
    if (err) { return helpers.handleError(res, err); }
    if(!volunteer_event) { return res.send(404); }
    var updated = _.merge(volunteer_event, req.body);
    updated.save(function (err) {
      if (err) { return helpers.handleError(res, err); }
      return res.json(200, volunteer_event);
    });
  });
};

// Deletes a volunteer_event from the DB.
exports.destroy = function(req, res) {
  VolunteerEvent.findById(req.params.id, function (err, volunteer_event) {
    if(err) { return helpers.handleError(res, err); }
    if(!volunteer_event) { return res.send(404); }
    volunteer_event.remove(function(err) {
      if(err) { return helpers.handleError(res, err); }
      Event.update( { _id: volunteer_event.event, $inc: { n_volunteers: -1 }});
      return res.send(204);
    });
  });
};
