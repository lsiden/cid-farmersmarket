'use strict'

angular.module 'farmersmarketApp'
.controller 'EventCtrl', ($scope, $state, $q, flash, Auth, Event, VolunteerEvent, eventService) ->

  $scope.errors = {}
  $scope.volunteers = []
  $scope.message = ''

  $scope.registerVolunteer = (event_id) ->
    eventService.registerVolunteer event_id, (success) ->
      $scope.registered = success

  $scope.event = eventService.decorate Event.get { id: $state.params.id }
  $scope.volunteers = eventService.getUsersForEvent($scope.event)
  $scope.isUserRegistered = eventService.isUserRegistered($scope.event)
