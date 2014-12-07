'use strict';
/*jshint expr: true*/

var should = require('should');
var app = require('../../app');
var User = require('./user.model');

var user = new User({
  provider: 'local',
  name: 'Fake User',
  email: 'test@test.com',
  password: 'password'
});

describe('User Model', function(done) {
  beforeEach(function(done) {
    User.remove(function(err) {
      done(err);
    });
  });

  afterEach(function(done) {
    User.remove(function(err) {
      done(err);
    });
  });

  it('should begin with no users', function(done) {
    User.find({}, function(err, users) {
      if (err) { return done(err); }
      users.should.have.length(0);
      done();
    });
  });

  it('should fail when saving a duplicate user', function(done) {
    user.save(function(err) {
      if (err) { return done(err); }
      var userDup = new User(user);
      userDup.save(function(err) {
        // if (err) { return done(err); }
        should.exist(err);
        done();
      });
    });
  });

  it('should fail when saving without an email', function(done) {
    user.email = '';
    user.save(function(err) {
      // if (err) { return done(err); }
      should.exist(err);
      done();
    });
  });

  it("should authenticate user if password is valid", function(done) {
    user.authenticate('password').should.be.true;
    done();
  });

  it("should not authenticate user if password is invalid", function(done) {
    user.authenticate('blah').should.not.be.true;
    done();
  });
});
