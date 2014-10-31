'use strict'

`
Date.prototype.addDays = function(hrs) {
  this.setDate(this.getDate() + hrs);
  return this;
};
`

angular.module 'farmersmarketApp'
.controller 'EventsCtrl', ['$scope', '$http', 'Event', ($scope, $http, Event) ->
  $scope.errors = {}

  # http://stackoverflow.com/a/24082603/270511
  $scope.gridData = {}
  $scope.gridOptions = { data: 'gridData' }

  makeGridEvent = (event) ->
    gridEvent = {}
    gridEvent[key] = event[key] for key in ['name', 'start', 'end', 'active']
    gridEvent

  # request all events that haven't ended
  query = { end: '>' + (new Date()).addDays(-1) };
  console.log(query);
  Event.get query, (events) ->
    $scope.gridData = (makeGridEvent(event) for event in events)

]
