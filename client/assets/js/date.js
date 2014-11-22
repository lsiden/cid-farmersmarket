// Add some helpers to Date
'use strict';

Date.prototype.addDays = function(days) {
  this.setDate(this.getDate() + days);
  return this;
};

Date.prototype.addHours = function(hrs) {
  this.setHours(this.getHours() + hrs);
  return this;
};

var timeFromMin = function(min) {
  if (min >= 24*60) { return undefined; }
  else if (min === 0) { return 'midnight'; }
  else if (min === 12*60) { return 'noon'; }

  var hr = Math.floor(min / 60);
  var xmin = min % 60;
  var meridian = hr < 12 ? 'am' : 'pm';

  if (hr >= 12) {
    hr -= 12;
  }

  if (xmin === 0) {
    return hr + meridian;
  }

  if (xmin < 10) {
    xmin = '0' + xmin;
  }
  return hr + ':' + xmin + ' ' + meridian;
};

Date.prototype.shortTime = function() {
  var min = 60 * this.getHours() + this.getMinutes();
  return timeFromMin(min);
};

Date.prototype.toYmd = function() {
  var y = this.getFullYear();
  var m = 1 + this.getMonth();
  var d = this.getDay();

  if (m < 10) { m = '0' + m; }
  if (d < 10) { d = '0' + d; }

  return [y, m, d].join('-');
};
