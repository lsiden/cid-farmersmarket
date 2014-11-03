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
  # calEvents = []
  # $scope.calEventSources = [events: calEvents]

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

  # Request all events that haven't ended
  query = { end: '>' + (new Date()).addDays(-1) }
  # console.log(query);

  Event.get query, (events) ->
    $scope.events = (makeEventItem event for event in events)
    # calEvents.length = 0

    # for event in events
    #   calEvents.push makeCalendarEventItem(event)
  ]

m.controller 'AdminEventCtrl', ['$scope', '$http', 'Event', ($scope, $http, Event) ->
  $scope.errors = {}
  $scope.event = {}
  $scope.actionTitle = 'Edit'
  ]
