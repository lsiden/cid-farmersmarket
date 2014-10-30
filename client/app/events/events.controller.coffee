'use strict'

angular.module 'farmersmarketApp'
.controller 'EventsCtrl', ['$scope', '$http', 'Event', ($scope, $http, Event) ->
  $scope.errors = {}
  $scope.events = {}

  # http://stackoverflow.com/a/24082603/270511
  $scope.gridData = {}
  $scope.gridOptions = { data: 'gridData' }

  makeGridEvent = (event) ->
    gridEvent = {}
    gridEvent[key] = event[key] for key in ['name', 'date', 'duration', 'active']
    gridEvent

  Event.get (events) ->
    #console.log(events)
    $scope.events = events
    $scope.gridData = (makeGridEvent(event) for event in events)

]
