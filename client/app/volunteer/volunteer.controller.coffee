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
    VolunteerEvent.findOrCreate params, (data, headers) ->
      console.log(data)
      console.log(headers)
      # TODO send confirmation mail to admin and to volunteer
      url = '/volunteer/:volunteer_id/event/:event_id/confirm'
      .replace(/:volunteer_id/, volunteerId)
      .replace(/:event_id/, $state.params.event_id)
      console.log(url)
      $location.path(url)
    , (headers) ->
      flash.error = 'VolunteerEvent.findOrCreate(): ' + headers

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
    sponsor: ''
    date: ''
    hours: ''

  Event.get { id: $state.params.event_id }, (event) ->
    start = new Date(event.start)
    end = new Date(event.end)

    $scope.event = 
      name: event.name
      sponsor: event.sponsor
      date: start.toDateString()
      hours: start.shortTime() + ' - ' + end.shortTime()
  , (headers) ->
    flash.error = 'Event.get(): ' + headers.data

  $scope.register = ->
    # Look up volunteer by e-mail and create record if none existed.
    data =
      email: $scope.volunteer.email
      name: $scope.volunteer.name
      phone: $scope.volunteer.phone

    Volunteer.findOrCreate data, (volunteer) ->
      console.log('Volunteer.findOrCreate returns')
      console.log(volunteer)
      saveVolunteerEvent(volunteer._id)
    , (headers) ->
      flash.error = 'Volunteer.save(): ' + headers.data
