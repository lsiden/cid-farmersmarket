'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  
  # Display a registration form for given event.
  $stateProvider.state 'register-volunteer',
    url: '/event/:event_id/register'
    templateUrl: 'app/events/register.html'
    controller: 'RegisterVolunteerEventCtrl'
  
  # Display a confirmation page verifying that volunteer has registered for an event.
  $stateProvider.state 'confirm-volunteer',
    url: '/event/:event_id/volunteer/:volunteer_id/confirm?confirmed'
    templateUrl: 'app/events/confirm.html'
    controller: 'ConfirmCtrl'

  $stateProvider.state 'event',
    url: '/event/:id'
    templateUrl: 'app/events/event.html'
    controller: 'EventCtrl'

#   $stateProvider.state 'events',
#     url: '/events'
#     templateUrl: 'app/events/events.html'
#     controller: 'EventsCtrl'
