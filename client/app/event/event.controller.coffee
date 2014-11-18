'use strict'

angular.module 'farmersmarketApp'
.controller 'EventCtrl', ($scope, $state, $q, flash, Auth, Event, VolunteerEvent, eventService) ->

  $scope.errors = {}
  $scope.volunteers = []
  $scope.user = Auth.getCurrentUser()
  $scope.message = ''

  $scope.registerVolunteer = (event_id) ->
    eventService.registerVolunteer event_id, (success) ->
      $scope.user.isRegistered = success
      $scope.volunteers.push $scope.user

  $scope.unregisterVolunteer = (event_id) ->
    eventService.unregisterVolunteer event_id, (success) ->
      $scope.user.isRegistered = !success
      volunteers = angular.copy($scope.volunteers)
      $scope.volunteers.length = 0
      $scope.volunteers.push v for v in volunteers when v._id != $scope.user._id

  $scope.event = eventService.decorate Event.get { id: $state.params.id }, (event) ->
    $scope.volunteers = eventService.getUsersForEvent(event._id)
    eventService.userRegistered($scope.user, event._id)
