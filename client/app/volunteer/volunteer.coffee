'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider.state 'volunteer',
    url: '/volunteer/:id'
    templateUrl: 'app/volunteer/volunteer.html'
    controller: 'VolunteerCtrl'
  $stateProvider.state 'volunteer.register',
    url: '/register/:event_id'
    templateUrl: 'app/volunteer/register.html'
    controller: 'VolunteerCtrl'
  $stateProvider.state 'volunteer.confirm',
    url: '/confirm/:event_id'
    templateUrl: 'app/volunteer/confirm.html'
    controller: 'VolunteerCtrl'
