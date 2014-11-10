'use strict';

var _ = require('lodash');
var Event = require('./event.model');

// Get list of events
exports.index = function(req, res) {
  if (req.query.end && req.query.end[0] === '>') {
    req.query.end = { $gt: new Date(req.query.end.substr(1)) };
  }
  // console.log(req.query);

  Event.find(req.query, function (err, events) {
    if(err) { return handleError(res, err); }
    Event.populate(events, { path: 'organization' }, function(err, populatedEvents) {
      if(err) { return handleError(res, err); }
      return res.json(200, populatedEvents);
    })
    // return res.json(200, events);
  });
};

// Get a single event
exports.show = function(req, res) {
  Event.findById(req.params.id, function (err, event) {
    if(err) { return handleError(res, err); }
    if(!event) { return res.send(404); }
    event.populate('organization', function(err, populatedEvent) {
      return res.json(populatedEvent);
    });
  });
};

// Creates a new event in the DB.
exports.create = function(req, res) {
  Event.create(req.body, function(err, event) {
    if(err) { return handleError(res, err); }
    return res.json(201, event);
  });
};

// Updates an existing event in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Event.findById(req.params.id, function (err, event) {
    if (err) { return handleError(res, err); }
    if(!event) { return res.send(404); }
    var updated = _.merge(event, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, event);
    });
  });
};

// Deletes a event from the DB.
exports.destroy = function(req, res) {
  Event.findById(req.params.id, function (err, event) {
    if(err) { return handleError(res, err); }
    if(!event) { return res.send(404); }
    event.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
