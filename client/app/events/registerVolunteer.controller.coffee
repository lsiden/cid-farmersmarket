'use strict'

angular.module 'farmersmarketApp'
.controller 'RegisterVolunteerEventCtrl', ($scope, $location, $state, flash, Event, Volunteer, VolunteerEvent) ->

  # Create volunteer_event record if none existed.
  registerVolunteerEvent = (volunteerId) ->
    if (!volunteerId) 
      throw 'saveVolunteerEvent(): missing arg \'volunteerId\''

    if (!$state.params.event_id) 
      throw 'saveVolunteerEvent(): missing $state.params_event_id'

    qParams = { volunteer: volunteerId, event: $state.params.event_id } # query params
    sParams = { volunteer_id: volunteerId, event_id: $state.params.event_id } # state params

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
      organization: 
        id: event.organization._id
        name: event.organization.name
        contact: event.organization.contact
        phone: event.organization.phone
        email: event.organization.email

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
      registerVolunteerEvent(volunteer._id)
    , (headers) ->
      flash.error = 'Volunteer.save(): ' + headers.data
