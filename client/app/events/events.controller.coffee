'use strict'

m = angular.module 'farmersmarketApp'

m.controller 'EventsCtrl', ($scope, Event) ->
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
    organization: event.organization

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

m.directive 'eventSummary', ($compile, $location) ->
  restrict: 'E'
  scope:
    volunteer: '='
    event: '='
  templateUrl: 'app/events/eventSummary.html'
  link: (scope, el, attrs) ->
    scope.register = (event_id) ->
      $location.path('volunteer/event/:event_id/register'.replace(/:event_id/, event_id))

m.filter 'decorateNumVolunteers', ->
  (num) ->
    if (num == 0)
      return 'None'
    num
