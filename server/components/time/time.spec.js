'use strict';

var should = require('should');
var time = require('../time');

var setTime = function(date, hr, min) {
  date.setHours(hr);
  date.setMinutes(min);
  return date;
};

Date.prototype.setHrMin = function(hr, min) {
  this.setHours(hr);
  this.setMinutes(min);
  return this;
}

describe('time Component', function() {

  it('should return a string representation of minutes past midnight', function(done) {
    time.timeFromMin(0).should.be.exactly('midnight');
    time.timeFromMin(12*60).should.be.exactly('noon');
    time.timeFromMin(6*60).should.be.exactly('6am');
    time.timeFromMin(6*60 + 30).should.be.exactly('6:30 am');
    time.timeFromMin(18*60).should.be.exactly('6pm');
    time.timeFromMin(18*60 + 30).should.be.exactly('6:30 pm');
    (time.timeFromMin(24*60) === undefined).should.be.true;
    done();
  });

  it('should return a string representation of time of day', function(done) {
    var date = new Date;
    time.timeFromDate(date.setHrMin(0, 0)).should.be.exactly('midnight');
    time.timeFromDate(date.setHrMin(12, 0)).should.be.exactly('noon');
    time.timeFromDate(date.setHrMin(6, 0)).should.be.exactly('6am');
    time.timeFromDate(date.setHrMin(6, 30)).should.be.exactly('6:30 am');
    time.timeFromDate(date.setHrMin(18, 0)).should.be.exactly('6pm');
    time.timeFromDate(date.setHrMin(18, 30)).should.be.exactly('6:30 pm');
    done();
  });

  it('should define Date.shortTime()', function(done) {
    var date = new Date;
    date.setHrMin(0, 0).shortTime().should.be.exactly('midnight');
    date.setHrMin(12, 0).shortTime().should.be.exactly('noon');
    date.setHrMin(6, 0).shortTime().should.be.exactly('6am');
    date.setHrMin(6, 30).shortTime().should.be.exactly('6:30 am');
    date.setHrMin(18, 0).shortTime().should.be.exactly('6pm');
    date.setHrMin(18, 30).shortTime().should.be.exactly('6:30 pm');
    done();
  });

/*
  it('should define Date.yyyymmdd()', function(done) {
    var date = new Date(2014, 6, 4); // Fourth of July
    date.yyyymmdd().should.be.exactly('20140704');
    done();
  });

  it('should return minutes from midnight given hr, min', function(done) {
    (time.minFromTime(24, 0) === undefined).should.be.true;
    time.minFromTime(12, 0, 'am').should.be.exactly(0);
    time.minFromTime(12, 30, 'am').should.be.exactly(30);
    time.minFromTime(12, 0, 'pm').should.be.exactly(12*60);
    time.minFromTime(1, 0, 'am').should.be.exactly(1*60);
    time.minFromTime(1, 30, 'am').should.be.exactly(1*60 + 30);
    time.minFromTime(1, 0, 'pm').should.be.exactly(13*60);
    time.minFromTime(1, 30, 'pm').should.be.exactly(13*60 + 30);
    time.minFromTime(0, 0).should.be.exactly(0);
    time.minFromTime(12, 0).should.be.exactly(12*60);
    time.minFromTime(23, 59).should.be.exactly(24*60 - 1);
    done();
  })
*/
});
