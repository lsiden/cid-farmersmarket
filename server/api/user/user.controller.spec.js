'use strict';

require('../../../client/assets/js/date.js')
require('../../config/seed');

var should = require('should');
var app = require('../../app');
var request = require('supertest');
var User = require('./user.model');
var tracer = require('tracer').console({ level: 'debug' });

describe('GET /api/users', function() {
  // before(function() {
  // });

  it('should respond with JSON array', function(done) {
    request(app)
      .get('/api/users')
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.should.be.instanceof(Array);
        done();
      });
  });

  it('should respond to an array of ObjectId', function(done) {
    User.find().limit(1).exec(function(err, users) {
      if (err) return done(err);
      tracer.debug(users);
      var query = users.map(function(user) {
        return '_id[]=' + user._id
      }).join('&');
      tracer.debug(query);
      request(app)
      .get('/api/users?' + query)
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.should.be.instanceof(Array);
        res.body.length.should.equal(1);
        done();
      });
    });
  });

});
