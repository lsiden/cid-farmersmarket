'use strict';

var _ = require('lodash');
var helpers = require('../helpers.service');
var Event = require('./event.model');
var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

// Get list of events
exports.index = function(req, res) {
  // if (req.query.end && req.query.end[0] === '>') {
  //   req.query.end = { $gte: new Date(req.query.end.substr(1)) };
  // } else if (req.query.end && req.query.end[0] === '<') {
  //   req.query.end = { $lte: new Date(req.query.end.substr(1)) };
  // }

  if (req.query.from || req.query.thru) {
    var range = {};
    if (req.query.from) {
      range.$gte = new Date(req.query.from);
      delete req.query.from;
    }
    if (req.query.thru) {
      range.$lte = new Date(req.query.thru);
      delete req.query.thru;
    }
    req.query.end = range;
  }
  // mongoose.set('debug', true);
  Event.find(helpers.processQuery(req.query), function (err, events) {
    if(err) { return helpers.handleError(res, err); }
    Event.populate(events, { path: 'organization' }, function(err, populatedEvents) {
      // mongoose.set('debug', false);
      if(err) { return helpers.handleError(res, err); }
      return res.json(200, populatedEvents);
    })
    // return res.json(200, events);
  });
};

// Get a single event
exports.show = function(req, res) {
  Event.findById(req.params.id, function (err, event) {
    if(err) { return helpers.handleError(res, err); }
    if(!event) { return res.send(404); }
    event.populate('organization', function(err, populatedEvent) {
      return res.json(populatedEvent);
    });
  });
};

// Creates a new event in the DB.
exports.create = function(req, res) {
  Event.create(req.body, function(err, event) {
    if(err) { return helpers.handleError(res, err); }
    return res.json(201, event);
  });
};

// Updates an existing event in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Event.findById(req.params.id, function (err, event) {
    if (err) { return helpers.handleError(res, err); }
    if(!event) { return res.send(404); }
    if (req.body.organization && req.body.organization._id) {
      req.body.organization = Schema.Types.ObjectId(req.body.organization._id);
    }
    var updated = _.merge(event, req.body);
    updated.save(function (err) {
      if (err) { return helpers.handleError(res, err); }
      return res.json(200, event);
    });
  });
};

// Deletes a event from the DB.
exports.destroy = function(req, res) {
  Event.findById(req.params.id, function (err, event) {
    if(err) { return helpers.handleError(res, err); }
    if(!event) { return res.send(404); }
    event.remove(function(err) {
      if(err) { return helpers.handleError(res, err); }
      return res.send(204);
    });
  });
};
