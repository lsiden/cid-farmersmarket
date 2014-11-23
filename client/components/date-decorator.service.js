'use strict';

angular.module('farmersmarketApp')
.factory('DateDecorator', function() {

  Date.prototype.addDays = function(hrs) {
    this.setDate(this.getDate() + hrs);
    return this;
  };

  return {};
});
