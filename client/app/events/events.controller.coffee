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
    gridEvent =
      Event: event.name
      Date: (new Date(event.start)).toDateString()
      Starts: (new Date(event.start)).shortTime()
      Ends: (new Date(event.end)).shortTime()
      # active: event.active # TODO make this available to admin only

    gridEvent

  # Request all events that haven't ended
  # TODO - show only active events for visitors.
  query = { end: '>' + (new Date()).addDays(-1) };
  # console.log(query);
  Event.get query, (events) ->
    $scope.gridData = (makeGridEvent(event) for event in events)

]
