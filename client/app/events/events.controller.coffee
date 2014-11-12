'use strict'

m = angular.module 'farmersmarketApp'

m.controller 'EventsCtrl', ($scope, flash, Event) ->
  $scope.errors = {}
  $scope.events = []
  $scope.calendarConfig = {}
  $scope.calendarEvents = []

  makeEventItem = (event) ->
    id: event._id
    name: event.name
    date: (new Date(event.start)).toDateString()
    starts: (new Date(event.start)).shortTime()
    ends: (new Date(event.end)).shortTime()
    volunteers: event.volunteers
    volunteerSlots: event.volunteerSlots
    organization: 
      id: event.organization._id
      name: event.organization.name
      contact: event.organization.contact
      phone: event.organization.phone
      email: event.organization.email

  makeCalendarEventItem = (event) ->
    title: event.name
    start: event.start

  # Request all events that haven't ended
  # TODO - show only active events for visitors.
  query = 
    end: '>' + (new Date()).addDays(-1)
    active: true
  # console.log(query);

  Event.query query, (events) ->
    $scope.events = (makeEventItem event for event in events)

    # see lsiden comment on https://github.com/angular-ui/ui-calendar/issues/71
    $scope.calendarEvents.length = 0
    $scope.calendarEvents.push (makeCalendarEventItem(event) for event in events)
  , (headers) ->
    flash.error = headers.data.message

  $scope.setCalendarView = (view) ->
    $scope.calendar.fullCalendar('changeView', view)
    
    # avoid "Error: [$parse:isecdom] Referencing DOM nodes in Angular expressions is disallowed!"
    # see https://docs.angularjs.org/error/$parse/isecdom
    null

m.directive 'eventSummary', ($state) ->
  restrict: 'E'
  scope:
    volunteer: '='
    event: '='
  templateUrl: 'app/events/eventSummary.html'
  link: (scope, el, attrs) ->
    scope.register = (event_id) ->
      $state.go('register-volunteer', { event_id: event_id })

m.filter 'decorateNumVolunteers', ->
  (num) ->
    if (num == 0)
      return 'None'
    num
