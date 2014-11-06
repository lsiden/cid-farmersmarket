'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  
  # Displays a list of events that volunteer has registered for.
  $stateProvider.state 'volunteer',
    url: '/volunteer/:volunteer_id'
    templateUrl: 'app/volunteer/volunteer.html'
    controller: 'VolunteerCtrl'
  
  # Display a registration form for given event.
  $stateProvider.state 'volunteer-register',
    url: '/volunteer/event/:event_id/register'
    templateUrl: 'app/volunteer/register.html'
    controller: 'VolunteerCtrl'
  
  # Display a confirmation page verifying that volunteer has registered for an event.
  $stateProvider.state 'volunteer-confirm',
    url: '/volunteer/:volunteer_id/event/:event_id/confirm'
    templateUrl: 'app/volunteer/confirm.html'
    controller: 'VolunteerCtrl'

  # Display a confirmation page verifying that volunteer has registered for an event.
  $stateProvider.state 'volunteer-reconfirm',
    url: '/volunteer/:volunteer_id/event/:event_id/reconfirm?date'
    templateUrl: 'app/volunteer/reconfirm.html'
    controller: 'VolunteerCtrl'
