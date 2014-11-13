'use strict'

# Controller for editing one event

angular.module 'farmersmarketApp'
.controller 'AdminEventCtrl', ($scope, $location, $state, flash, dialogs, Event, Organization, eventService) ->
  $scope.errors = {}
  eventId = $state.params.id
  
  if (eventId && eventId != 'new')
    $scope.actionTitle = 'Edit'
    $scope.event = eventService.decorate Event.get { id: eventId }, (event) ->
      $scope.masterEvent = angular.copy($scope.event)
    , (headers) ->
      flash.error = headers.data.message
  else
    $scope.actionTitle = 'New'
    $scope.event = eventService.decorate(new Event)

  # Used by form selector.
  $scope.organizations = Organization.query (organizations) ->
    makeOrganizationItem = (organization) ->
      name: organization.name
      id: organization._id

    $scope.organizations = (makeOrganizationItem org for org in organizations)

  $scope.isEventChanged = (event) ->
    !angular.equals(event, $scope.masterEvent)

  $scope.resetEvent = ->
    $scope.event = angular.copy($scope.masterEvent)
    
  $scope.saveEvent = (form) ->
    if !form.$valid
      return

    $scope.submitted = true
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
        # $location.path('/admin/events')
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

    # FIXME Buttons are labelled "DIALOG_YES" and "DIALOG_NO".
    dlg = dialogs.confirm('Confirmation required', 'You are about to delete the event \':name\'.'.replace(/:name/, ev.name))
    dlg.result.then (btn) ->
      ev.$remove (err, data) ->
        $location.path('admin/events')
      , (headers) ->
        flash.error = headers.message
