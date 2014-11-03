'use strict'

m = angular.module 'farmersmarketApp'

m.controller 'AdminEventsCtrl', ['$scope', '$http', 'Event', ($scope, $http, Event) ->
  $scope.errors = {}
  $scope.events = []
  $scope.eventGridOptions = { data: 'events' }

  # For Angular ui.calendar widget
  calEvents = []
  $scope.calEventSources = [events: calEvents]

  makeEventItem = (event) ->
    start = new Date(event.start)
    end = new Date(event.end)

    name: event.name
    sponsor: event.sponsor
    date: start.toDateString()
    hours: start.shortTime() + ' - ' + end.shortTime()
    attendance: '' + event.volunteers + '/' + event.volunteerSlots
    active: event.active

  makeCalendarEventItem = (event) ->
    title: event.name
    start: event.start

  # Request all events that haven't ended
  query = { end: '>' + (new Date()).addDays(-1) }
  # console.log(query);

  Event.get query, (events) ->
    $scope.events = (makeEventItem event for event in events)
    calEvents.length = 0

    for event in events
      calEvents.push makeCalendarEventItem(event)
  ]
