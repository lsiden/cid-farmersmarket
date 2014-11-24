'use strict'

makeCalendarEventItem = (event) ->
  title: event.name
  start: event.start

angular.module 'farmersmarketApp'
.controller 'MainCtrl', ($scope, $rootScope, Auth, eventService) ->

  $scope.calendarConfig = {}
  $scope.calendarEvents = []
  $scope.registeredEvents = eventService.getEventsForUser(Auth.getCurrentUser()._id)
  $scope.events = eventService.currentEvents { active: true }, (events) ->
    eventService.decorate event for event in events
    # see lsiden comment on https://github.com/angular-ui/ui-calendar/issues/71
    $scope.calendarEvents.length = 0
    $scope.calendarEvents.push (makeCalendarEventItem(event) for event in events)
  , (headers) ->
    flash.error = headers.message

  $scope.$watch 'getCurrentUser()', (user, oldUser) ->
    if user != oldUser
      $scope.registeredEvents = eventService.getEventsForUser(user)

  $scope.setCalendarView = (view) ->
    $scope.calendar.fullCalendar('changeView', view)
    
    # avoid "Error: [$parse:isecdom] Referencing DOM nodes in Angular expressions is disallowed!"
    # see https://docs.angularjs.org/error/$parse/isecdom
    null

  $scope.registerVolunteer = (event_id) ->
    eventService.registerVolunteer(event_id)
