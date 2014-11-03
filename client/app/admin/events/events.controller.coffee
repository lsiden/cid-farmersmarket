'use strict'

# TODO - Define sort function for Date column to not be alphabetical.
# Limit sorting to Name, Sponsor, and Date.
# Replace Active cells with checkbox

m = angular.module 'farmersmarketApp'

m.controller 'AdminEventsCtrl', ['$scope', '$http', '$state', 'Event', ($scope, $http, $state, Event) ->
  $scope.errors = {}
  $scope.events = []
  $scope.eventGridOptions = 
    data: 'events'
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/events/name.cell.template.html'
      }
      { field: 'sponsor', displayName: 'Sponsor' }
      { field: 'date', displayName: 'Date' }
      { field: 'hours', displayName: 'Hours' }
      { field: 'attendance', displayName: 'Attendance' }
      { field: 'active', displayName: 'Active' }
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
