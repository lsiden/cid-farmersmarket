'use strict'

angular.module 'farmersmarketApp'
.controller 'EventsCtrl', ($scope, flash, Event, eventService) ->
  $scope.errors = {}
  $scope.events = eventService.currentEvents { active: true }, (events) ->
    eventService.decorate event for event in events
