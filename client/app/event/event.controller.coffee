'use strict'

angular.module 'farmersmarketApp'
.controller 'EventCtrl', ($scope, $state, $q, flash, Auth, Event, VolunteerEvent, eventService) ->

  $scope.errors = {}
  $scope.volunteers = []
  $scope.user = Auth.getCurrentUser()
  $scope.message = ''

  $scope.registerVolunteer = (event_id) ->
    eventService.registerVolunteer event_id, (success) ->
      $scope.registered = success

  $scope.event = eventService.decorate Event.get { id: $state.params.id }, (event) ->
    $scope.volunteers = eventService.getUsersForEvent(event._id)
    eventService.userRegistered($scope.user, event._id)
