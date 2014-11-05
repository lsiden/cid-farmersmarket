'use strict'

# TODO - Define sort function for Date column to not be alphabetical.
# Limit sorting to Name, Sponsor, and Date.
# Replace Active cells with checkbox

m = angular.module 'farmersmarketApp'

m.controller 'AdminEventsCtrl', ['$scope', '$http', '$state', 'Event', ($scope, $http, $state, Event) ->

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
      { field: 'sponsor', displayName: 'Sponsor', sortable: true }
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

    href: $state.href('admin-event', { id: event._id })
    name: event.name
    sponsor: event.sponsor
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
    flash.error = headers.data.message
  ]

m.controller 'AdminEventCtrl', ['$scope', '$http', '$location', '$state', 'dialogs', 'Event', 
($scope, $http, $location, $state, dialogs, Event) ->
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
    sponsor: ''
    about: ''
    volunteerSlots: 3
    date: startDate
    startTime: startDate
    endTime: endDate
    active: false
  $scope.masterEvent = angular.copy($scope.event)

  id = $location.path().split('/').pop()

  if (id != 'new')
    $scope.actionTitle = 'Edit'
    Event.get { id: id }, (event) ->
      _event = event
      $scope.event =
        id: event._id
        name: event.name
        sponsor: event.sponsor
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
      if (id == 'new')
        data =
          name: ev.name
          sponsor: ev.sponsor
          about: ev.about
          volunteerSlots: ev.volunteerSlots
          start: composeDateTime(ev.date, ev.startTime)
          end: composeDateTime(ev.date, ev.endTime)

        Event.save data, (data, header) ->
          $scope.message = 'Created new event.'
        , (res) ->
          $scope.message = 'Cannot create your event now.'

      else
        # Use the original instance
        _event.name = ev.name
        _event.sponsor = ev.sponsor
        _event.about = ev.about
        _event.volunteerSlots = ev.volunteerSlots
        _event.start = composeDateTime(ev.date, ev.startTime)
        _event.end = composeDateTime(ev.date, ev.endTime)

        _event.$update (data, header) ->
          $scope.message = 'Event successfully changed.'

        , (headers) ->
          flash.error = headers.data.message

  $scope.deleteEvent = ->
    ev = $scope.event
    if ev.id == 'new' then return

    # FIXME Buttons are labelled "DIALOG_YES" and "DIALOG_NO".
    dlg = dialogs.confirm('Confirmation required', 'You are about to delete the event \':name\'.'.replace(/:name/, ev.name))
    dlg.result.then (btn) ->
      _event.$remove (err, data) ->
        $state.go('admin-events')
    # , (btn) ->
    #   $scope.confirmed = 'You confirmed "No."'

  ]
