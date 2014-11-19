'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'admin-events',
    url: '/admin/events'
    templateUrl: 'app/admin/event/index/events.html'
    controller: 'AdminEventsCtrl'
    authenticate: true
  
  .state 'admin-event-edit',
    url: '/admin/events/:id/edit'
    templateUrl: 'app/admin/event/edit/event.html'
    controller: 'AdminEventEditCtrl'
    authenticate: true
  
  .state 'admin-event',
    url: '/admin/events/:id'
    templateUrl: 'app/admin/event/event.html'
    controller: 'AdminEventCtrl'
    authenticate: true
