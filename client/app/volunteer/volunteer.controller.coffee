'use strict'

angular.module 'farmersmarketApp'
.controller 'VolunteerCtrl', ($scope, $location, $state, flash, Event, Volunteer, VolunteerEvent) ->

  # Create volunteer_event record if none existed.
  saveVolunteerEvent = (volunteerId) ->
    if (!volunteerId) 
      throw('saveVolunteerEvent(): missing arg \'volunteerId\'')

    if (!$state.params.event_id) 
      throw('saveVolunteerEvent(): missing $state.params_event_id')

    params = { volunteer_id: volunteerId, event_id: $state.params.event_id }
    VolunteerEvent.query params, (volunteerEvents) ->
      path = '/volunteer/:volunteer_id/event/:event_id'
      .replace /:volunteer_id/, volunteerId
      .replace /:event_id/, $state.params.event_id
      
      if volunteerEvents && volunteerEvents.length
        # Volunteer has already registered for this event.
        # $state.go('volunteer-reconfirm', _.merge( { date: volunteerEvents[0].createdAt }, params))
        return $location.path(path + '/reconfirm').search 
          date: volunteerEvents[0].createdAt

      volunteerEvent = new VolunteerEvent params
      volunteerEvent.$save (data, headers) ->
        # TODO send confirmation mail to admin and to volunteer
        $location.path(path + '/confirm')
      , (headers) ->
        flash.error = 'volunteerEvent.$save(): ' + headers

  $scope.errors = {}
  $scope.message = ''

  # attributes come from DOM
  $scope.volunteer =
    email: ''
    name: ''
    phone: ''
  
  # attributes come from DB
  $scope.event =
    href: ''
    name: ''
    organization: ''
    date: ''
    hours: ''

  Event.get { id: $state.params.event_id }, (event) ->
    start = new Date(event.start)
    end = new Date(event.end)

    $scope.event = 
      name: event.name
      organization: event.organization
      date: start.toDateString()
      hours: start.shortTime() + ' - ' + end.shortTime()
  , (headers) ->
    flash.error = 'Event.get(): ' + headers.data

  $scope.register = ->
    # Look up volunteer by e-mail and create record if none existed.
    volunteer = new Volunteer
      email: $scope.volunteer.email
      name: $scope.volunteer.name
      phone: $scope.volunteer.phone

    volunteer.$save (volunteer) ->
      # console.log(volunteer)
      saveVolunteerEvent(volunteer._id)
    , (headers) ->
      flash.error = 'Volunteer.save(): ' + headers.data
