'use strict';

var should = require('should');
var app = require('../../app');
var request = require('supertest');
var User = require('../user/user.model');
var Event = require('../event/event.model');
var VolunteerEvent = require('./volunteer_event.model');
var helpers = require('../helpers.service')
var async = require('async');

var createUsers = function(n, done) {
  var userParams = [];
  for (var i=0 ; i < n ; ++i) {
    userParams.push({
      provider: 'local',
      name: 'Test User ' + i,
      email: 'test_:i@test.com'.replace(/:i/, i),
      password: 'test',
      active: true,
      role: 'user'
    });
  }
  User.find().remove(function(err) {
    if (err) { return done(err); }
    User.create(userParams, function(err) {
      if (err) { return done(err); }
      var tracer = require('tracer').console({ level: 'warn' });
      tracer.debug(arguments);
      done(err, Array.prototype.slice.call(arguments, 1));
    });
  });
};

var createEvents = function(n, done) {
  var eventParams = [];
  for (var i=0 ; i < n ; ++i) {
    eventParams.push({
      provider: 'local',
      name: 'Event ' + i,
      active: true,
      volunteerSlots: 10
    });
  }
  Event.find().remove(function(err) {
    if (err) { return done(err); }
    Event.create(eventParams, function(err) {
      if (err) { return done(err); }
      done(err, Array.prototype.slice.call(arguments, 1));
    });
  });
};

describe('GET /api/volunteer_events', function() {

  var users = [];
  var events = [];
  var volunteerEvents = [];

  beforeEach(function(done) {
    // Create some users and events.
    async.parallel([
      function(cb) { createUsers(3, cb); },
      function(cb) { createEvents(3, cb); }
      ], function(err, results) {
        var tracer = require('tracer').console({ level: 'warn' });
        tracer.debug(results);
        users = results[0];
        events = results[1];
        users.length.should.be.equal(3);
        events.length.should.be.equal(3);

        VolunteerEvent.find({}).remove(function(err) {
          if (err) return done(err);
          VolunteerEvent.create({
            volunteer: users[0]._id,
            event: events[0]._id
          }, function(err, res) {
            if (err) return done(err);
            var tracer = require('tracer').console({ level: 'warn' });
            volunteerEvents = [ res ];
            tracer.debug(users);
            tracer.debug(volunteerEvents);
            // users[0] is registered to events[0]
            done(err);
          });
      });
    });
  });

  it('should respond with JSON array', function(done) {
    request(app).get('/api/volunteer_events')
    .expect(200)
    .expect('Content-Type', /json/)
    .end(function(err, res) {
      if (err) return done(err);
      res.body.should.be.instanceof(Array);
      done();
    });
  });

  it('volunteer can unregister', function(done) {
    helpers.withAuthUser(users[0], function(err, token, results) {
      request(app).delete('/api/volunteer_events/' + volunteerEvents[0]._id)
      // see https://github.com/DaftMonk/generator-angular-fullstack/issues/494#issuecomment-53716281
      .set('authorization', 'Bearer ' + token)
      .expect(204)
      .end(function(err) { done(err); });
    });
  });

  it("volunteer cannot unregister from event he isn't registered for", function(done) {
    var tracer = require('tracer').console({ level: 'warn' });
    helpers.withAuthUser(users[1], function(err, token, results) {
      request(app).delete('/api/volunteer_events/' + volunteerEvents[0]._id)
      // see https://github.com/DaftMonk/generator-angular-fullstack/issues/494#issuecomment-53716281
      .set('authorization', 'Bearer ' + token)
      .expect(403)
      .end(function(err) { done(err); });
    });
  });
});
