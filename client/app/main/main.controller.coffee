'use strict'

angular.module 'farmersmarketApp'
.controller 'MainCtrl', ($scope, $rootScope, Auth, eventService) ->

  $scope.calendarConfig = {}
  $scope.calendarEvents = []
  $scope.registeredEvents = eventService.registeredByVolunteer(Auth.getCurrentUser())
  $scope.events = eventService.currentEvents { active: true }, (events) ->
    eventService.decorate event for event in events
    makeCalendarEventItem = (event) ->
      title: event.name
      start: event.starft
    # see lsiden comment on https://github.com/angular-ui/ui-calendar/issues/71
    $scope.calendarEvents.length = 0
    $scope.calendarEvents.push (makeCalendarEventItem(event) for event in events)
  , (headers) ->
    flash.error = headers.message

  $scope.getCurrentUser = ->
    Auth.getCurrentUser()

  $scope.$watch 'getCurrentUser()', (user, oldUser) ->
    if user != oldUser
      $scope.registeredEvents = eventService.registeredByVolunteer(user)

  $scope.setCalendarView = (view) ->
    $scope.calendar.fullCalendar('changeView', view)
    
    # avoid "Error: [$parse:isecdom] Referencing DOM nodes in Angular expressions is disallowed!"
    # see https://docs.angularjs.org/error/$parse/isecdom
    null

  $scope.registerVolunteer = (event_id) ->
    eventService.registerVolunteer(event_id)
