'use strict';

var should = require('should');
var app = require('../../app');
var request = require('supertest');
var Event = require('./event.model');
var EventSeed = require('./event.seed');

describe('GET /api/events', function() {
  before(function() {
    Event.find({}).remove(function() {
      var startDate = new Date();
      startDate.setHours(11);
      startDate.setMinutes(0);
      startDate =- 60 * 24 * 3600 * 1000; // 60 days ago
      EventSeed.seedEvents(startDate, 4, 12, 7, function() {});
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

  it('should respond to an array of ObjectId', function(done) {
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

  it('should respond to from-thru query', function(done) {
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
});
