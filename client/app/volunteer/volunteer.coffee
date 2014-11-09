'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  
  # Displays a list of events that volunteer has registered for.
  $stateProvider.state 'volunteer',
    url: '/volunteer/:volunteer_id'
    templateUrl: 'app/volunteer/volunteer.html'
    controller: 'VolunteerCtrl'
