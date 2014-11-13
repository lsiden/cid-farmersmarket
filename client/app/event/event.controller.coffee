'use strict'

angular.module 'farmersmarketApp'
.controller 'EventCtrl', ($scope, $state, $q, flash, Auth, Event, VolunteerEvent, eventService) ->

  $scope.errors = {}
  $scope.message = ''

  $scope.registerVolunteer = (event_id) ->
    eventService.registerVolunteer(event_id)

  $scope.event = eventService.decorate(Event.get { id: $state.params.id })
  $scope.registered = undefined

  $q.all [Auth.getCurrentUser().$promise, $scope.event.$promise]
  .then (results) ->
    [user, event] = results

    if user._id and event._id
      VolunteerEvent.query { volunteer: user._id, event: event._id }, (volunteerEvents) ->
        $scope.registered = !!volunteerEvents.length
    else
      $scope.registered = false
  , (headers) ->
    flash.error = 'Event.get(): ' + headers.data

