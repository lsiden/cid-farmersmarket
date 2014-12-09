'use strict';

var _ = require('lodash');
var helpers = require('../helpers.service');
var Event = require('./event.model');
var mongoose = require('mongoose'),
    Schema = mongoose.Schema;
var tracer = require('tracer').console({ level: 'info' });

// Notify org contact and volunteers that event has changed.
var notifyVolunteers = function(req, event, action) {
  // var tracer = require('tracer').console({ level: 'debug' });
  var async = require('async');
  var User = require('../user/user.model');
  var VolunteerEvent = require('../volunteer_event/volunteer_event.model');

  async.parallel([
    function(done) {User.find({ role: 'admin' }, done); },
    function(done) {
      // find all volunteers for this event
      VolunteerEvent.find({ event: event._id })
      .populate('volunteer')
      .select('volunteer: 1')
      .exec(function(err, ar) {
        done(err, ar);
      });
    }], function(err, results) {
      // var tracer = require('tracer').console({ level: 'debug' });
      // tracer.debug(results);
      var message;
      var admins = results[0];
      var volunteers = results[1];
      var mandrillSvc = require('../../components/mail/mandrill.service');
      var event_url = 'http://' + req.headers.host + '/events/' + event._id;
      var event_link = '<a href=":url">' + event.name + '</a>';
      var to = [{
        name: event.organization.contact,
        email: event.organization.email
      }].concat(volunteers.map(function(vol) {
        return { name: vol.name, email: vol.email };
      }));
      var cc = admins.map(function(admin) {
        return { name: admin.name, email: admin.email };
      });
      switch (action) {
        case 'rescheduled':
        message = 'The event :event_link has been changed.  Please take note of any new information including the date and time.'
        .replace(/:event_link/, event_link);
        break;
        
        case 'cancelled':
        message = 'The event :event_name has been cancelled.  We appreciate your interest and hope you will volunteer again.'
        .replace(/:event_name/, event.name);
        break;

        default:
        tracer.error('VolunteerEvent.notifyVolunteers(), bad param=' + action);
        return;
      }
      mandrillSvc.send(to, cc, 'event changed', message, function(err, res) {
        tracer.info(res);
        if (err) { tracer.error(err); }
      });
    });
};

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
  Event.findById(req.params.id)
  .populate('organization')
  .exec(function (err, event) {
    if (err) { return helpers.handleError(res, err); }
    if (!event) { return res.send(404); }
    if (req.body.organization && req.body.organization._id) {
      req.body.organization = Schema.Types.ObjectId(req.body.organization._id);
    }
    var updated = _.merge(event, req.body);
    updated.save(function (err) {
      if (err) { return helpers.handleError(res, err); }
      res.json(200, event);
      notifyVolunteers(req, event, 'rescheduled');
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
      res.send(204);
      notifyVolunteers(req, event, 'cancelled');
    });
  });
};
