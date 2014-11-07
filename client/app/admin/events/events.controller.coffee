'use strict'

# TODO - Define sort function for Date column to not be alphabetical.
# Limit sorting to Name, Organization, and Date.
# Replace Active cells with checkbox

m = angular.module 'farmersmarketApp'

m.controller 'AdminEventsCtrl', ($scope, $location, flash, Event) ->

  sortByDate = (_a, _b) ->
    a = new Date(_a)
    b = new Date(_b)
    
    if a < b then return -1
    if a > b then return 1
    return 0

  $scope.errors = {}
  $scope.events = []
  $scope.eventGridOptions = 
    data: 'events'
    sortInfo: { fields: ['date'], directions: ['asc'] }
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/events/name.cell.template.html'
        sortable: true
      }
      { field: 'organization', displayName: 'Organization', sortable: true }
      { field: 'date', displayName: 'Date', sortable: true, sortFn: sortByDate }
      { field: 'hours', displayName: 'Hours', sortable: false }
      { field: 'attendance', displayName: 'Volunteers/Slots', sortable: false }
      { field: 'active', displayName: 'Active', sortable: false }
    ]

  # For Angular ui.calendar widget
  # $scope.calEventSources = { events: [] }

  makeEventItem = (event) ->
    start = new Date(event.start)
    end = new Date(event.end)

    href: '/admin/events/' + event._id
    name: event.name
    organization: event.organization
    date: start.toDateString()
    hours: start.shortTime() + ' - ' + end.shortTime()
    attendance: '' + event.volunteers + '/' + event.volunteerSlots
    active: event.active

  # makeCalendarEventItem = (event) ->
  #   title: event.name
  #   start: event.start

  query = { end: '>' + (new Date()).addDays(-1) }
  # Request all events that haven't ended
  # console.log(query);

  Event.query query, (events) ->
    $scope.events = (makeEventItem event for event in events)
    #$scope.calEventSources.events = (makeCalendarEventItem(event) for event in events)
  , (headers) ->
    flash.error = headers.message

m.controller 'AdminEventCtrl', ($scope, $location, $state, flash, dialogs, Event) ->
  $scope.errors = {}
  $scope.actionTitle = 'New'

  # New event starts tomorrow, from 12-4pm.
  startDate = (new Date).addDays(1) # tomorrow
  startDate.setHours(12)
  startDate.setMinutes(0)
  endDate = new Date(startDate)
  endDate.setHours(4)
  endDate.setMinutes(0)
  _event = null # the event instance from the server

  $scope.event =
    id: 'new'
    name: ''
    organization: ''
    about: ''
    volunteerSlots: 3
    date: startDate
    startTime: startDate
    endTime: endDate
    active: false
  $scope.masterEvent = angular.copy($scope.event)

  # eventId = $location.path().split('/')[3]
  eventId = $state.params.id

  if (eventId != 'new')
    $scope.actionTitle = 'Edit'
    Event.get { id: eventId }, (event) ->
      _event = event
      $scope.event =
        id: event._id
        name: event.name
        organization: event.organization
        about: event.about
        volunteerSlots: event.volunteerSlots
        date: new Date(event.start)
        startTime: new Date(event.start)
        endTime: new Date(event.end)
        active: event.active
      $scope.masterEvent = angular.copy($scope.event)

    , (headers) ->
      flash.error = headers.data.message

  $scope.isEventChanged = (event) ->
    !angular.equals(event, $scope.masterEvent)

  $scope.resetEvent = ->
    $scope.event = angular.copy($scope.masterEvent)

  # Both date and time are instances of Date.
  composeDateTime = (date, time) ->
    result = new Date(date)
    result.setHours(time.getHours())
    result.setMinutes(time.getMinutes())
    
  $scope.saveEvent = (form) ->
    $scope.submitted = true
    ev = $scope.event

    if form.$valid
      if (eventId == 'new')
        _event = new Event()

      _event.name = ev.name
      _event.organization = ev.organization
      _event.about = ev.about
      _event.volunteerSlots = ev.volunteerSlots
      _event.start = composeDateTime(ev.date, ev.startTime)
      _event.end = composeDateTime(ev.date, ev.endTime)
      _event.active = ev.active

      if (eventId == 'new')
        _event.$save (data, headers) ->
          flash.success = 'Created new event.'
          $state.go('admin-events')
        , (headers) ->
          flash.error = headers.message

      else
        _event.$update (data, headers) ->
          flash.success = 'Modified event info.'
          # $location.path('/admin/events')
          $state.go('admin-events')
        , (headers) ->
          flash.error = headers.message

  $scope.deleteEvent = ->
    ev = $scope.event
    if ev.id == 'new' then return

    # FIXME Buttons are labelled "DIALOG_YES" and "DIALOG_NO".
    dlg = dialogs.confirm('Confirmation required', 'You are about to delete the event \':name\'.'.replace(/:name/, ev.name))
    dlg.result.then (btn) ->
      _event.$remove (err, data) ->
        $location.path('admin/events')
    # , (btn) ->
    #   $scope.confirmed = 'You confirmed "No."'
