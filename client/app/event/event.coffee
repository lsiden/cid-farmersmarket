'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  
  # Display a registration form for given event.
  $stateProvider.state 'event',
    url: '/event/:id'
    templateUrl: 'app/event/event.html'
    controller: 'EventCtrl'
  
  # Display a confirmation page verifying that volunteer has registered for an event.
  $stateProvider.state 'confirm-volunteer',
    url: '/event/:id/confirm?confirmed'
    templateUrl: 'app/event/confirm.html'
    controller: 'ConfirmCtrl'

#   $stateProvider.state 'events',
#     url: '/events'
#     templateUrl: 'app/events/events.html'
#     controller: 'EventsCtrl'
