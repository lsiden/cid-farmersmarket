'use strict'

angular.module 'farmersmarketApp'
.controller 'ConfirmCtrl', ($scope, $state, $location, $q, flash, Event, User) ->
  # Expecting $state.params = { volunteer_id: ..., event_id: ... }

  $scope.errors = {}
  $scope.event = {}
  $scope.registeredDate = null
  $scope.registeredTime = null

  sdate = $state.params.confirmed
  console.log(sdate)
  
  if sdate
    date = new Date(sdate)
    $scope.registeredDate = date.toDateString()
    $scope.registeredTime = date.shortTime()

  # $scope.event =
  #   name: 'Test Event'
  #   date: 'Sunday'
  #   startTime: '1pm'
  #   endTime: '4pm'
  #   organization:
  #     name: 'Org 1'
  #     contact: 'Mr. Contact'
  #     email: 'info@org1.org'
  #     phone: '555-5555'

  $scope.volunteer = {}
  # $scope.volunteer =
  #   id: 'volunteer_1'
  #   name: 'Mr. Volunteer'
  #   phone: '555-5555'
  #   email: 'my@email.com'
  
  # console.log $state.params
  $q.all
    event: (Event.get id: $state.params.event_id).$promise
    volunteer: (User.get id: $state.params.volunteer_id).$promise
  .then (result) ->
    # console.log result
    event = result.event
    volunteer = result.volunteer
    $scope.event = 
      name: event.name
      date: (new Date(event.start)).toDateString()
      starts: (new Date(event.start)).shortTime()
      ends: (new Date(event.end)).shortTime()
      organization:
        id: event.organization._id
        name: event.organization.name
        contact: event.organization.contact
        email: event.organization.email
        phone: event.organization.phone
    $scope.volunteer =
       id: volunteer._id
       name: volunteer.name
       email: volunteer.email
       phone: volunteer.phone
  , (err) ->
    flash.error = err
