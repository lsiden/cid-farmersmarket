'use strict'

angular.module 'farmersmarketApp'
.controller 'RegisterVolunteerEventCtrl', ($scope, $state, flash, Event, VolunteerEvent, loginDlg, Auth) ->

  $scope.errors = {}
  $scope.message = ''
  $scope.event = EventDecorator.decorate(new Event)

  Event.get { id: $state.params.event_id }, (event) ->
    $scope.event = EventDecorator.decorate(event)
  , (headers) ->
    flash.error = 'Event.get(): ' + headers.data

  $scope.register = ->
    if !Auth.isLoggedIn
      return
    uid = Auth.getCurrentUser._id

    if (!$state.params.event_id) 
      throw 'saveVolunteerEvent(): missing $state.params_event_id'

    qParams = { volunteer: uid, event: $state.params.event_id } # query params
    sParams = { volunteer_id: uid, event_id: $state.params.event_id } # state params

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
