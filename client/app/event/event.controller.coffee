'use strict'

angular.module 'farmersmarketApp'
.controller 'EventCtrl', ($scope, $state, $cookieStore, flash, Auth, Event, VolunteerEvent, EventDecorator) ->

  $scope.errors = {}
  $scope.message = ''
  $scope.event = EventDecorator.decorate(new Event())

  Event.get { id: $state.params.id }, (event) ->
    $scope.event = EventDecorator.decorate(event)
  , (headers) ->
    flash.error = 'Event.get(): ' + headers.data

  $scope.register = ->
    if !Auth.isLoggedIn()
      $cookieStore.put 'after-login-state', ['event', { id: $state.params.id }]
      $state.go('login')
      return

    uid = Auth.getCurrentUser._id

    if (!$state.params.id) 
      throw 'saveVolunteerEvent(): missing $state.params.id'

    qParams = { volunteer: uid, event: $state.params.id } # query params
    sParams = { id: $state.params.id } # state params

    VolunteerEvent.query qParams, (volunteerEvents) ->
      if volunteerEvents && volunteerEvents.length
        # Volunteer has already registered for this event.
        return $state.go('confirm-volunteer', _.merge( { confirmed: volunteerEvents[0].createdAt }, sParams))

      volunteerEvent = new VolunteerEvent(qParams)
      volunteerEvent.$save (data, headers) ->
        # TODO send confirmation mail to admin and to volunteer
        $state.go 'confirm-volunteer', sParams
      , (headers) ->
        flash.error = 'volunteerEvent.$save(): ' + headers
