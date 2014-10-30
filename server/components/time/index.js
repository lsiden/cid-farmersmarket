// Store time as minutes from midnight.
// Format into human-readable string.

'use strict';

var timeFromMin = function(min) {
  if (min >= 24*60) return undefined;
  else if (min === 0) return 'midnight';
  else if (min === 12*60) return 'noon';

  var hr = Math.floor(min / 60);
  var min = min % 60;
  var xm = hr < 12 ? 'am' : 'pm';

  if (hr >= 12) {
    hr -= 12;
  }

  if (min === 0) {
    return hr + xm;
  }

  if (min < 10) {
    min = '0' + min;
  }
  return hr + ':' + min + ' ' + xm;
};

// Return string representation of time from minutes past midnight.
// Use popular am/pm format.
exports.timeFromMin = function(min) {
  return timeFromMin(min);
};

exports.timeFromDate = function(date) {
  var min = 60 * date.getHours() + date.getMinutes();
  return timeFromMin(min);
};


Date.prototype.shortTime = function() {
  var min = 60 * this.getHours() + this.getMinutes();
  return timeFromMin(min);
};

/*
// Convert hour and minutes past the hour into minutes past midnight.
exports.minFromTime = function(hr, min, xm) {
  if (xm) {
    var xm = xm.toLowerCase();
    if (hr == 12 && xm == 'am') hr = 0;
    else if (hr != 12 && xm == 'pm') hr += 12;
  }
  var val = 60 * hr + min;
  if (val > 24*60-1) return undefined;

  return val;
}
*/
