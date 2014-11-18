'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'admin-events',
    url: '/admin/events'
    templateUrl: 'app/admin/event/index/events.html'
    controller: 'AdminEventsCtrl'
    authenticate: true
  
  .state 'admin-event',
    url: '/admin/events/:id'
    templateUrl: 'app/admin/event/event.html'
    controller: 'AdminEventCtrl'
    authenticate: true
