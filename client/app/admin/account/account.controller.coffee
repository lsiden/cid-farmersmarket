'use strict'

angular.module 'farmersmarketApp'
.controller 'AccountCtrl', ($scope, $state, flash, User, Event, VolunteerEvent, adminService, eventService) ->
  $scope.submitted = false
  $scope.errors = {}
  $scope.user_master = {}
  $scope.formerEvents = []
  $scope.currentEvents = []
  $scope.events = []
  $scope.attended = 0
  $scope.trackRecord = ''
  $scope.eventGridOptions = adminService.eventGridOptions
  $scope.user = User.get { id: $state.params.id }, (user) ->
    $scope.user_master = angular.copy(user)

  # Get list of events that volunteer has registered for.
  VolunteerEvent.query { volunteer: $state.params.id }, (ar_ve) ->
    if ar_ve.length > 0
      hash_ve = {}
      hash_ve[ve.event._id] = ve.event for ve in ar_ve
      $scope.events = Event.query { '_id[]': ( ve.event._id for ve in ar_ve )}, (events) ->
        eventService.decorate event for event in events
        events.sort (a, b) ->
          return 0 if a.start == b.start
          return 1 if a.start > b.start
          return -1
        today = new Date()
        $scope.formerEvents.push ev for ev in events when new Date(ev.end) < today
        $scope.currentEvents.push ev for ev in events when new Date(ev.end) >= today
        event.attended = hash_ve[event._id].attended for event in $scope.formerEvents
        attended = (1 for ve in ar_ve when ve.attended).length
        $scope.trackRecord = [attended, $scope.formerEvents.length].join('/')

  $scope.reset = (form) ->
    $scope.user = angular.copy($scope.user_master)

  $scope.submit = (form) ->
    $scope.submitted = true
    return unless form.$valid

    $scope.user.$update (user) ->
      flash.success = 'Updated account ' + user.email
      $state.go('admin-accounts')
    , (headers) ->
      flash.error = headers.message

  $scope.isUserChanged = ->
    !angular.equals($scope.user, $scope.user_master)

  $scope.roles = [
    { name: 'Admin', _id: 'admin' }
    { name: 'User', _id: 'user' }
  ]

  $scope.resetPassword = ->
    flash.error = 'not yet implemented'

  $scope.toggleAttended = (event) ->
    VolunteerEvent.query { volunteer: $state.params.id, event: event._id }, (ar_ve) ->
      if ar_ve.length > 0
        ve = ar_ve[0]
        ve.attended = event.attended
        ve.$update (ve1) ->
          flash.success = 'Recorded attendance.'
        , (headers) ->
          flash.error = headers.message
