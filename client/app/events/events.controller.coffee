'use strict'

m = angular.module 'farmersmarketApp'

m.controller 'EventsCtrl', ($scope, flash, Event, eventService) ->
  $scope.errors = {}
  $scope.events = []
  $scope.calendarConfig = {}
  $scope.calendarEvents = []

  # Date.prototype.addDays() not available during unit testing.
  d = new Date()
  endDate = d.setDate(d.getDate() + -1);

  # Request all events that haven't ended
  query = 
    # end: '>' + (new Date()).addDays(-1)
    end: '>' + endDate
    active: true
  # console.log(query);

  $scope.events = Event.query query, (events) ->
    $scope.events = (eventService.decorate event for event in events)

    makeCalendarEventItem = (event) ->
      title: event.name
      start: event.start

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

m.directive 'eventSummary', ($state, eventService) ->
  restrict: 'E'
  scope:
    event: '='
  templateUrl: 'app/event/event-summary.html'
  controller: ($scope) ->
    $scope.visitEvent = (id) ->
      eventService.visitEvent id

m.filter 'decorateNumVolunteers', ->
  (num) ->
    if (num == 0)
      return 'None'
    num
