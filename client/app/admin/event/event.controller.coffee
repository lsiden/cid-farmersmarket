'use strict'

# Controller for editing one event

angular.module 'farmersmarketApp'
.controller 'AdminEventCtrl', ($scope, $state, flash, Modal, Event, Organization, eventService) ->
  $scope.errors = {}
  eventId = $state.params.id
  
  if (eventId && eventId != 'new')
    $scope.actionTitle = 'Edit'
    $scope.event = eventService.decorate Event.get { id: eventId }, (event) ->
      $scope.masterEvent = angular.copy(event)
    , (headers) ->
      flash.error = headers.message
    $scope.masterEvent = angular.copy $scope.event
  else
    $scope.actionTitle = 'New'
    $scope.event = eventService.decorate(new Event)
    $scope.masterEvent = angular.copy $scope.event

  # Used by form selector.
  $scope.organizations = Organization.query (organizations) ->
    makeOrganizationItem = (organization) ->
      name: organization.name
      id: organization._id

    $scope.organizations = (makeOrganizationItem org for org in organizations)

  $scope.isEventChanged = ->
    !angular.equals($scope.event, $scope.masterEvent)

  $scope.resetEvent = ->
    $scope.event = angular.copy($scope.masterEvent)
    
  $scope.saveEvent = (form) ->
    $scope.submitted = true
    return unless form.$valid

    ev = $scope.event

    # Both date and time are instances of Date.
    composeDateTime = (date, time) ->
      result = new Date(date)
      result.setHours(time.getHours())
      result.setMinutes(time.getMinutes())
      result

    ev.start = composeDateTime(ev.date, ev.startTime)
    ev.end = composeDateTime(ev.date, ev.endTime)

    if (ev._id)
      ev.$update (data, headers) ->
        flash.success = 'Modified event info.'
        $state.go('admin-events')
      , (headers) ->
        flash.error = headers.message
    else
      ev.$save (data, headers) ->
        flash.success = 'Created new event.'
        $state.go('admin-events')
      , (headers) ->
        flash.error = headers.message

  $scope.deleteEvent = ->
    ev = $scope.event
    if ev.id == 'new' then return

    del = ->
      ev.$remove ->
        _.remove $scope.users, ev
        $state.go 'admin-events'
      , (headers) ->
        flash.error = headers.message
    
    Modal.confirm.delete(del) ev.name