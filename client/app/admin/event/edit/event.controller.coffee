'use strict'

# Controller for editing one event

composeDate = (isoDate, time) ->
  date = new Date(isoDate)
  tdate = new Date(time)
  date.setHours(tdate.getHours())
  date.setMinutes(tdate.getMinutes())
  date

angular.module 'farmersmarketApp'
.controller 'AdminEventEditCtrl', ($scope, $state, flash, Modal, Event, Organization, eventService) ->
  $scope.errors = {}
  eventId = $state.params.id
  $scope.organizations = Organization.query() # Used by form selector.
  $scope.event = Event.get { id: eventId }, (event) ->
    eventService.decorate event
    $scope.masterEvent = angular.copy(event)
  , (headers) ->
    flash.error = headers.message
  $scope.masterEvent = angular.copy $scope.event

  $scope.isEventChanged = ->
    !angular.equals($scope.event, $scope.masterEvent)

  $scope.resetEvent = ->
    $scope.event = angular.copy($scope.masterEvent)
    
  $scope.saveEvent = (form) ->
    $scope.submitted = true
    return unless form.$valid

    $scope.event.start = composeDate($scope.event.isoDate, $scope.event.start)
    $scope.event.end = composeDate($scope.event.isoDate, $scope.event.end)

    # Length of event must be between 0 and 24 hours, by caveat.
    if ($scope.event.end < $scope.event.start)
      $scope.event.end.addDays(1);

    if ($scope.event._id)
      $scope.event.$update (data, headers) ->
        flash.success = 'Modified event info.'
        $state.go('admin-events')
      , (headers) ->
        flash.error = headers.message
    else
      $scope.event.$save (data, headers) ->
        flash.success = 'Created new event.'
        $state.go('admin-events')
      , (headers) ->
        flash.error = headers.message

  $scope.deleteEvent = ->
    if $scope.event._id == 'new' then return

    del = ->
      $scope.event.$remove ->
        _.remove $scope.users, $scope.event
        $state.go 'admin-events'
      , (headers) ->
        flash.error = headers.message
    
    Modal.confirm.delete(del) $scope.event.name
