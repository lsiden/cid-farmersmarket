'use strict'

# Controller for editing one event

composeDate = (isoDate, time) ->
  date = new Date(isoDate)
  tdate = new Date(time)
  date.setHours(tdate.getHours())
  date.setMinutes(tdate.getMinutes())
  date

angular.module 'farmersmarketApp'
.controller 'AdminEventEditCtrl', ($scope, $state, flash, Event, User, VolunteerEvent, Organization, eventService) ->
  
  $scope.errors = {}
  $scope.organizations = Organization.query() # Used by form selector.
  $scope.event = Event.get { id: $state.params.id }, (event) ->
    eventService.decorate event
    $scope.masterEvent = angular.copy(event)
    User.query { event: $scope.event._id }, (users) ->
      $scope.volunteers = users
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
      $scope.event.end += 24 * 3600 * 1000;

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
    eventService.deleteEvent $scope.event, (deleted) ->
      if deleted
        $state.go 'admin-events'

  $scope.volunteerGridOptions = 
    data: 'volunteers'
    enableRowSelection: false
    enableCellSelection: false
    sortInfo: { fields: ['name'], directions: ['asc'] }
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/account/index/name.cell.template.html'
        sortable: true
      }
      {
        field: 'email'
        displayName: 'Email'
        cellTemplate: 'app/admin/account/index/email.cell.template.html'
        sortable: false
      }
      { field: 'phone', displayName: 'Phone', sortable: false }
      {
        field: 'attended'
        displayName: 'Attended'
        cellTemplate: 'app/admin/account/index/attended.cell.template.html'
        sortable: false
      }
    ]

  $scope.toggleAttended = (user) ->
    VolunteerEvent.query { volunteer: user._id, event: $state.params.id }, (ar_ve) ->
      if ar_ve.length > 0
        ve = ar_ve[0]
        ve.attended = event.attended
        ve.$update (ve1) ->
          flash.success = 'Recorded attendance.'
        , (headers) ->
          flash.error = headers.message
