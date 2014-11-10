'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  
  $stateProvider.state 'volunteer',
    url: '/volunteer/:id'
    templateUrl: 'app/volunteer/volunteer.html'
    controller: 'VolunteerCtrl'
