'use strict';
/*jshint expr: true*/

var tracer = require('tracer').console({ level: 'info' });
var should = require('should');
var app = require('../../app');
var request = require('supertest');
var User = require('./user.model');
// var Seed = require('../../config/seed');
var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var helpers = require('../helpers.service');

var createUsers = function(done) {
  var users_params = [
  {
    provider: 'local',
    name: 'Admin',
    email: "admin@admin.com",
    password: 'admin',
    role: 'admin',
    active: true
  },
  {
    provider: 'local',
    name: 'New User',
    email: "new@user.com",
    password: 'password',
    role: 'user',
    active: true
  }];
  User.find().remove(function(err) {
    if (err) { return done(err); }
    User.create(users_params, function(err) {
      done(err, Array.prototype.slice.call(arguments, 1));
    });
  });
};

var teardown = function(done) {
  User.find().remove(function(err) {
    done(err);
  });
};

describe('/api/users', function(done) {
  var users = null;
  var token;  // auth token

  beforeEach(function(done) {
    tracer.trace('beforeEach');
    createUsers(function(err, _users) {
      if (err) { return done(err); }
      users = _users;

      request(app).post('/auth/local')
      .send({email: _users[0].email, password: _users[0].password })
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        token = res.body.token;
        done();
      });
    });
  });

  afterEach(teardown);

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

  it('should create a new user', function(done) {
    request(app)
    .post('/api/users')
    .send({
      name: 'New User 2',
      email: "newer@user.com",
      password: 'password',
      active: true
    })
    .expect(201)
    .expect('Content-Type', /json/)
    .end(function(err, res) {
      if (err) return done(err);
      res.body.should.be.instanceof(Object);
      res.body.token.should.be.instanceof(String);
      done();
    });
  });
  
  it('admin can fetch a user', function(done) {
    var user = users[1];
    request(app).get('/api/users/' + user._id)
      .set('authorization', 'Bearer ' + token) // see https://github.com/DaftMonk/generator-angular-fullstack/issues/494#issuecomment-53716281
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        tracer.log(res.body);
        res.body.should.be.instanceof(Object);
        (res.body.hashedPassword === undefined).should.be.true;
        (res.body.salt === undefined).should.be.true;
        res.body._id.should.be.equal('' + user._id);
        done();
      });
    });

  it('admin can update a user', function(done) {
    var user = users[1];
    request(app)
    .put('/api/users/' + user._id)
    .send({
      active: false
    })
    .set('authorization', 'Bearer ' + token)
    .expect(200)
    .expect('Content-Type', /json/)
    .end(function(err, res) {
      if (err) return done(err);
      res.body.should.be.instanceof(Object);
      res.body.active.should.be.false;
      done();
    });
  });
});
