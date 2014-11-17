'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  
  # Display a registration form for given event.
  $stateProvider.state 'event',
    url: '/events/:id'
    templateUrl: 'app/event/event.html'
    controller: 'EventCtrl'

#   $stateProvider.state 'events',
#     url: '/events'
#     templateUrl: 'app/events/events.html'
#     controller: 'EventsCtrl'
