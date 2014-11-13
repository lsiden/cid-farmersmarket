'use strict';

require ('../../../common/date');

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var _ = require('lodash');
var should = require('should');
var app = require('../../app');
var request = require('supertest');
var Event = require('./event.model');
var User = require('../user/user.model');
var EventSeed = require('./event.seed');
var async = require('async');
var VolunteerEvent = require('../volunteer_event/volunteer_event.model');

describe('GET /api/events', function() {

  var N_VOLUNTEERS = 3; // volunteers per event
  var i_volunteer = 1;
  var N_HOURS = 4;
  var EVERY_N_DAYS = 7;
  var N_EVENTS = 12;

  var seedVolunteers = function(event, callback) {
    // console.log('seedVolunteers()')
    var user_params = [];

    for (var i=0 ; i < N_VOLUNTEERS ; ++i) {
      user_params.push( {
        provider: 'local',
        // _id: 'volunteer_:i'.replace(/:i/, i_volunteer),
        name: 'Volunteer ' + i_volunteer,
        phone: '555-5555',
        email: 'volunteer_:i@volunteer'.replace(/:i/, i_volunteer),
        password: 'password',
        active: true
      });
      ++i_volunteer;
    }
    User.find().remove(function() {
      User.create(user_params, function(err) {
        // console.log('User.create() callback');
        if (err) console.log(err);
        if (err) return callback(err);
        // console.log(users);
        var ve_params = [];
        for (var i=1; i < arguments.length ; ++i) {
          var user = arguments[i];
          // console.log(user);
          ve_params.push({
            provider: 'local',
            volunteer: user._id,
            event: event._id
          });
        }
        // console.log('calling VolunteerEvent.create');
        // console.log(ve_params);
        VolunteerEvent.create(ve_params, function(err, vevents) {
          // console.log('VolunteerEvent callback');
          // console.log(err);
          // console.log(vevents);
          callback(err, vevents);
        });
      });
    });
  };

  before(function(done) {
    Event.find().remove(function() {
      var promises = [];
      var date = (new Date()).addDays(-30);
      date.setHours(11);
      date.setMinutes(0);
      // console.log(date);
      EventSeed.seedEvents(date, N_HOURS, N_EVENTS, EVERY_N_DAYS, function(err, events) {
        if (err) return done(err);
        events.forEach(function(event) {
          promises.push(function(callback) {
            seedVolunteers(event, function(err, result) {
              callback(err, result);
            });
          });
        });
        async.series(promises, function(err) {
          return done(err);
        });
      });
    });
  });

  it('setup should give each event an organization and some volunteers', function(done) {
    Event.findOne(function(err, event) {
      // console.log(event);
      event.should.be.ok;
      event.organization.should.be.ok;
      mongoose.Types.ObjectId.isValid(event.organization.toString()).should.be.ok;

      VolunteerEvent.find({event: event._id}, function(err, vevents) {
        vevents.length.should.be.ok;
        done();
      });
    });
  });

  it('should respond with JSON array', function(done) {
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

  it('should filter out events that ended', function(done) {
    var yesterday = (new Date()).addDays(-1);
    var url = '/api/events?end=>' + yesterday;
    // console.log('usl = ' + url);

    request(app)
      .get(url)
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.should.be.instanceof(Array);
        (res.body.length > 0).should.be.true;
        res.body.forEach(function(event) {
          //console.log(event.end);
          (new Date(event.end) > yesterday).should.be.true;
        });
        done();
      });
  });

/*
  it('should return volunteers with event', function(done) {
    Event.findOne(function(err, event) {
      request(app).get('/api/events/' + event._id)
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, event) {
        event.should.be.ok;
        event.volunteers.should.be.ok;
        event.volunteers.length.should.be.ok;
        event.volunteers[0].should.be.ok;

        VolunteerEvent.find({event: event._id}, function(err, vevents) {
          event.volunteers.length.should.equal(vevents.length);
          done();
        });
      });
    });
  });
*/
});
