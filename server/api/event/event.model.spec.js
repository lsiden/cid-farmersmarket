'use strict';

var should = require('should');
var app = require('../../app');
var Event = require('./event.model');
var eventParams = {
    provider: 'local',
    name: 'Special Event',
    about: 'About Test Event 1',
    date: new Date(2014, 11, 1, 13, 0, 0, 0),
    duration: 3,
    active: true
  };

describe('Event Model', function() {
  before(function(done) {
    // Clear events before testing
    Event.remove().exec().then(function() {
      done();
    });
  });

  afterEach(function(done) {
    Event.remove().exec().then(function() {
      done();
    });
  });

/*
  it('should begin with no events', function(done) {
    Event.find({}, function(err, events) {
      events.should.have.length(0);
      done();
    });
  });
*/

  it('should return a start time', function(done) {
    Event.create(eventParams, function(err, event) {
      if (err) {
        console.log(err);
      } else {
        (event !== undefined).should.be.true;
        (event.startTime().constructor === Date).should.be.true;
        done();
      }
    });
  });

  it('should return an end time', function(done) {
    Event.create(eventParams, function(err, event) {
      if (err) {
        console.log(err);
      } else {
        (event !== undefined).should.be.true;
        (event.endTime().constructor === Date).should.be.true;
        done();
      }
    });
  });
});
