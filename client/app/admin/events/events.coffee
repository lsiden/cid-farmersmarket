'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider.state 'admin-events',
    url: '/admin/events'
    templateUrl: 'app/admin/events/events.html'
    controller: 'AdminEventsCtrl'
