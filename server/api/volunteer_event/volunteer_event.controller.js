'use strict';

var _ = require('lodash');
var helpers = require('../helpers.service');
var VolunteerEvent = require('./volunteer_event.model');
var User = require('../user/user.model');
var Event = require('../event/event.model');
var Organization = require('../organization/organization.model');
var async = require('async');

var sendConfirmation = function(volunteer_event, action) {
  async.parallel({
    volunteer: function(done) { User.findById(volunteer_event.volunteer, done); },
    event: function(done) { Event.findById(volunteer_event.event).populate('organization').exec(done); },
    admins: function(done) { User.find({ role: 'admin' }, done); }
    }, function(err, results) {
      var to = [{ name: results.volunteer.name, email: results.volunteer.email }];
      var cc = [], message = '', subj = '';
      var mandrillSvc = require('../../components/mail/mandrill.service');

      if (action === 'register') {
        if (results.event.organization) {
          cc = [{ name: results.event.organization.contact, email: results.event.organization.email }];
        }
        results.admins.forEach(function(admin) {
          cc.push({ email: admin.email, name: admin.name });
        });
        subj = 'registration'
        message = "You are registered to volunteer for the Grand River Farmers' Market event :event_name, beginning on :start_time and ending at :end_time.  We look forward to seeing you there.  Thank you for volunteering."
        .replace(/:event_name/, results.event.name)
        .replace(/:start_time/, results.event.start.toLocaleString({ weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric' }))
        .replace(/:end_time/, results.event.end.toLocaleString({ hour: 'numeric', minute: 'numeric' }));
      } else if (action === 'cancel') {
        if (results.event.organization) {
          cc = [{ name: results.event.organization.contact, email: results.event.organization.email }];
        }
        results.admins.forEach(function(admin) {
          cc.push({ email: admin.email, name: admin.name });
        });
        subj = 'cancellation'
        message = "You have cancelled your volunteer committment to the Grand River Farmers' Market event :event_name, beginning on :start_time and ending at :end_time.  We hope will will find other opportunities to volunteer for Farmers' Market events.  Thank you for your interest."
        .replace(/:event_name/, results.event.name)
        .replace(/:start_time/, results.event.start.toLocaleString({ weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric' }))
        .replace(/:end_time/, results.event.end.toLocaleString({ hour: 'numeric', minute: 'numeric' }));
      } else if (action === 'attend') {
        subj = 'attend'
        message = "Your volunteer attendance at the Grand River Farmers' Market event :event_name, beginning on :start_time and ending at :end_time has been recorded.  We hope will will find more opportunities to volunteer for Farmers' Market events.  Thank you for your good work!"
        .replace(/:event_name/, results.event.name)
        .replace(/:start_time/, results.event.start.toLocaleString({ weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric' }))
        .replace(/:end_time/, results.event.end.toLocaleString({ hour: 'numeric', minute: 'numeric' }));
      } else { return; }
      mandrillSvc.send(to, cc, subj, message);
    });
};

// Get list of volunteer_events
exports.index = function(req, res) {
  // console.log(req.query);
  VolunteerEvent.find(req.query)
  .populate({path: 'volunteer', model: User })
  .populate({path: 'event', model: Event })
  .populate({path: 'event.organization', model: Organization })
  .exec(function (err, volunteer_events) {
    if(err) { return helpers.handleError(res, err); }
    res.json(200, volunteer_events);
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
    res.json(volunteer_event);
  });
};

// Creates a new volunteer_event in the DB if one does not already exist.
exports.create = function(req, res) {
  var tracer = require('tracer').console({ level: 'warn' });
  VolunteerEvent.findOne(req.body, function(err, volunteer_event) {
    if(err) { return helpers.handleError(res, err); }
    if (volunteer_event) { return res.json(201, volunteer_event); }
    tracer.log(req.body);
    VolunteerEvent.create(req.body, function(err, volunteer_event) {
      if(err) { return helpers.handleError(res, err); }
      tracer.log(volunteer_event);
      Event.update( { _id: volunteer_event.event}, { $inc: { n_volunteers: 1} }, function(err, num_affected, raw) {
        if(err) { return helpers.handleError(res, err); }
      });
      res.json(201, volunteer_event);
      sendConfirmation(volunteer_event, 'register')
    });
  });
};

// Updates an existing volunteer_event in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  if(req.body.volunteer) { delete req.body.volunteer; }
  if(req.body.event) { delete req.body.event; }
  // console.log(req.body);
  VolunteerEvent.findById(req.params.id, function (err, volunteer_event) {
    if (err) { return helpers.handleError(res, err); }
    if(!volunteer_event) { return res.send(404); }
    if (!req.user.role === 'admin' && !volunteer_event.volunteer.equals(req.user._id)) {
      return res.send(403, 'Can update only one\'s own event-volunteer registrations.');
    }
    var updated = _.merge(volunteer_event, req.body);
    updated.save(function (err) {
      if (err) { return helpers.handleError(res, err); }
      res.json(200, volunteer_event);
      sendConfirmation(volunteer_event, 'atttend')
    });
  });
};

// Deletes a volunteer_event from the DB.
exports.destroy = function(req, res) {
  var tracer = require('tracer').console({ level: 'warn' });
  VolunteerEvent.findById(req.params.id, function (err, volunteer_event) {
    if(err) { return helpers.handleError(res, err); }
    if(!volunteer_event) { return res.send(404); }
    if (!volunteer_event.volunteer.equals(req.user._id)) {
      return res.send(403, 'Can delete only one\'s own event-volunteer registrations.');
    }
    volunteer_event.remove(function(err) {
      if(err) { return helpers.handleError(res, err); }
      Event.update( { _id: volunteer_event.event, $inc: { n_volunteers: -1 }});
      res.send(204);
      sendConfirmation(volunteer_event, 'cancel')
    });
  });
};
