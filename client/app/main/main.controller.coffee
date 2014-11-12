'use strict'

angular.module 'farmersmarketApp'
.controller 'MainCtrl', ($scope, $rootScope, eventService) ->

  $scope.registerVolunteer = (event_id) ->
    eventService.registerVolunteer(event_id)
