'use strict'

m = angular.module 'farmersmarketApp'

m.controller 'EventsCtrl', ($scope, flash, Event, eventService) ->
  $scope.errors = {}
  $scope.events = eventService.currentEvents { active: true }, (events) ->
    eventService.decorate event for event in events

m.directive 'eventSummary', ($state) ->
  restrict: 'E'
  scope: true
    # event: '='
    # registeredEvents: '='
  templateUrl: 'app/event/event-summary.html'
  controller: ($scope) ->
    $scope.visitEvent = (id) ->
      $state.go 'event', { id: id }

m.filter 'decorateNumVolunteers', ->
  (num) ->
    if (num == 0)
      return 'None'
    num
