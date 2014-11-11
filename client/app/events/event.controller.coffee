'use strict'

angular.module 'farmersmarketApp'
.controller 'EventCtrl', ($scope, $state, flash, Event) ->
  $scope.event = {}
  Event.get { id: $state.params.id }, (event) ->
    $scope.event = angular.copy event
    start = new Date(event.start)
    end = new Date(event.end)
    $scope.event.sdate = start.toDateString()
    $scope.event.starts = start.shortTime()
    $scope.event.ends = end.shortTime()
  (headers) ->
    flash.error = headers.message
