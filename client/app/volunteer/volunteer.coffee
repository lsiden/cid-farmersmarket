'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  
  # Display a registration form for given event.
  $stateProvider.state 'volunteer-event',
    url: '/volunteer/event/:event_id'
    templateUrl: 'app/volunteer/register.html'
    controller: 'VolunteerCtrl'
  
  # Displays a list of events that volunteer has registered for.
  $stateProvider.state 'volunteer',
    url: '/volunteer/:id'
    templateUrl: 'app/volunteer/volunteer.html'
    controller: 'VolunteerCtrl'
  
  # Display a confirmation page verifying that volunteer has registered for an event.
  $stateProvider.state 'volunteer.confirm',
    url: '/confirm/:event_id'
    templateUrl: 'app/volunteer/confirm.html'
    controller: 'VolunteerCtrl'
