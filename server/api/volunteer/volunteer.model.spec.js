'use strict';

var should = require('should');
var app = require('../../app');
var Volunteer = require('./volunteer.model');

var volunteer = new Volunteer({
  provider: 'local',
  name: 'Fake Volunteer',
  email: 'test@test.com',
  password: 'password'
});

describe('Volunteer Model', function() {
  before(function(done) {
    // Clear volunteers before testing
    Volunteer.remove().exec().then(function() {
      done();
    });
  });

  afterEach(function(done) {
    Volunteer.remove().exec().then(function() {
      done();
    });
  });

  it('should begin with no volunteers', function(done) {
    Volunteer.find({}, function(err, volunteers) {
      volunteers.should.have.length(0);
      done();
    });
  });

  it('should fail when saving a duplicate volunteer', function(done) {
    volunteer.save(function() {
      var volunteerDup = new Volunteer(volunteer);
      volunteerDup.save(function(err) {
        should.exist(err);
        done();
      });
    });
  });

  it('should fail when saving without an email', function(done) {
    volunteer.email = '';
    volunteer.save(function(err) {
      should.exist(err);
      done();
    });
  });

});
