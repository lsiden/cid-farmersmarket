'use strict';

var should = require('should');
var app = require('../../app');
var request = require('supertest');
var User = require('../user/user.model');
var Event = require('./event.model');
var EventSeed = require('./event.seed');
var helpers = require('../helpers.service')
var tracer = require('tracer').console({ level: 'info' });

describe('/api/events', function(done) {
  var events = null;
  var users = null;

  var seedEvents = function(done) {
    var startDate = new Date();
    startDate.setHours(11);
    startDate.setMinutes(0);
    startDate =- 60 * 24 * 3600 * 1000; // 60 days ago
    EventSeed.seedEvents(startDate, 4, 12, 7, function(err, _events) {
      // tracer.trace(_events);
      done(err, _events);
    });
  };

  var seedUsers = function(done) {
    User.find({}).remove(function(err) {
      if (err) { return done(err); }
      User.create([
      {
        provider: 'local',
        role: 'admin',
        name: 'Admin',
        email: 'admin@admin.com',
        phone: '555-555-5555',
        active: true,
        password: 'admin'
      }, {
        provider: 'local',
        role: 'user',
        name: 'Test User',
        email: 'test@test.com',
        phone: '555-555-5555',
        active: true,
        password: 'test'
      }, {
        provider: 'local',
        role: 'user',
        name: 'Test User 2',
        email: 'test2@test.com',
        phone: '555-555-5555',
        active: true,
        password: 'test'
      }], function(err) {
        // tracer.trace(users);
        done(err, Array.prototype.slice.call(arguments, 1));
      });
    });
  };

  before(function(done) {
    var async = require('async');
    async.parallel([
      function(cb) { seedEvents(cb); },
      function(cb) { seedUsers(cb); }
      ], function(err, results) {
        if (err) { return done(err); }
        // tracer.trace(results);
        events = results[0];
        users = results[1];
        done();
      });
  });

  it('GET should respond with JSON array', function(done) {
    request(app)
      .get('/api/events')
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.should.be.instanceof(Array);
        done();
      });
  });

  it('GET should respond to an array of ObjectId', function(done) {
    Event.find({}).limit(3).exec(function(err, events) {
      if (err) return done(err);
      var query = events.map(function(ev) {
        return '_id[]=' + ev._id
      }).join('&');
      // console.log(query);
      request(app)
      .get('/api/events?' + query)
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.should.be.instanceof(Array);
        res.body.length.should.equal(3);
        done();
      });
    });
  });

  it('GET should respond to from-thru query', function(done) {
    request(app)
    .get('/api/events?from=2014-10-20&thru=2015-01-18')
    .expect(200)
    .expect('Content-Type', /json/)
    .end(function(err, res) {
      if (err) return done(err);
      res.body.should.be.instanceof(Array);
      // res.body.length.should.equal(3);
      done();
    });
  });

  it('PUT should respond with success', function(done) {
    var event = events[0];
    helpers.withAuthUser(users[0], function(err, token, res) {
      // tracer.debug(token);
      request(app).put('/api/events/' + event._id)
      .set('authorization', 'Bearer ' + token)
      .send({ name: 'New Event Name'})
      .expect(200)
      // .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) { return done(err); }
        res.body.should.be.instanceof(Object);
        done();
      });
    });
  });
});
