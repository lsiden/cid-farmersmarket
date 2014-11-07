'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'admin-events',
    url: '/admin/events'
    templateUrl: 'app/admin/events/events.html'
    controller: 'AdminEventsCtrl'
    authenticate: true
  
  .state 'admin-event',
    url: '/admin/events/:id'
    templateUrl: 'app/admin/events/event.html'
    controller: 'AdminEventCtrl'
    authenticate: true
