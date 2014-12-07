'use strict';
/*jshint expr: true*/

var should = require('should');
var app = require('../../app');
var request = require('supertest');
var async = require('async');
var ResetPw = require('./resetpw.model');
var mandrillSvc = require('../../components/mail/mandrill.service');
var User = require('../user/user.model');
var tracer = require('tracer').console({ level: 'info' });

describe('/api/resetpw', function(done) {

  var user;
  var resetpw;

  beforeEach(function(done) {
    User.find().remove(function(err) {
      if (err) { return done(err); }

      User.create({
        provider: 'local',
        email: 'test@test.com',
        name: 'Test User',
        password: 'forgot it!',
        role: 'user'
      }, function(err) {
        if (err) { return done(err); }

        var users = Array.prototype.slice.call(arguments, 1);
        user = users[0];

        ResetPw.find().remove(function(err) {
          if (err) { return done(err); }

          ResetPw.create({ user: user._id }, function(err, _resetpw) {
            if (err) { return done(err); }

            resetpw = _resetpw;
            done(err);
          });
        });
      });
    });
  });

  afterEach(function(done) {
    var wipeUser = function(done) {
      User.find().remove(function(err) {
        done(err);
      })
    };
    var wipeResetPw = function(done) {
      ResetPw.find().remove(function(err) {
        done(err);
      });
    };
    async.parallel([wipeUser, wipeResetPw], function(err) {
      done(err);
    });
  });

  it('POST should create a new instance', function(done) {
    request(app).post('/api/resetpw')
    .send({ email: user.email })
    .expect(204, function(err, res) {
      if (err) { 
        // tracer.debug(Object.keys(res));
        tracer.debug(res.text);
        return done(err); 
      }
      ResetPw.findOne({ user: user._id }, function(err, resetpw) {
        if (err) { return done(err); }
        resetpw.should.be.ok;
        // We have no way to test if the message was actually sent in test mode
        // because Mandrill will not even store a record for the message if it was rejected.
        done();
      });
    });
  });

  it('requesting another reset wipes the first instance', function(done) {
    request(app).post('/api/resetpw')
    .send({ email: user.email })
    .expect(204)
    .end(function(err, res) {
      if (err) { return done(err); }
      ResetPw.count({ user: user._id }, function(err, count) {
        if (err) { return done(err); }
        Number(count).should.equal(1);
        done();
      });
    });
  });

  it('GET /api/resetpw/:key with valid key will return a token', function(done) {
    var config = require('../../config/environment');
    ResetPw.create({ user: user._id }, function(err, resetpw) {
      if (err) { return done(err); }
      // var tracer = require('tracer').console({ level: 'debug' });
      tracer.debug(resetpw);
      request(app).get('/api/resetpw/' + resetpw.key)
      .expect('set-cookie', /connect.sid/)
      .end(function(err, res) {
        if (err) { return done(err); }
        res.body.should.match(/token/);
        done()
      });
    });
  });

  it('GET /api/resetpw/:key with invalid key results in redirect', function(done) {
    ResetPw.create({ user: user._id }, function(err, resetpw) {
      if (err) { return done(err); }
      request(app).get('/api/resetpw/' + 'badkey')
      .expect(302, done);
    });
  });

});
