'use strict';

var should = require('should');
var app = require('../../app');
var Event = require('./event.model');
var eventParams = {
    provider: 'local',
    name: 'Special Event',
    about: 'About Test Event 1',
    start: new Date(2014, 11, 1, 13, 0, 0, 0),
    end: new Date(2014, 11, 1, 17, 0, 0, 0),
    active: true
  };

describe('Event Model', function(done) {
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

});
