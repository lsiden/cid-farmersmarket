'use strict'

angular.module 'farmersmarketApp'
.directive 'eventSummary', ($state) ->
  restrict: 'E'
  scope: true
    # event: '='
    # registeredEvents: '='
  templateUrl: 'app/event/event-summary.html'
  controller: ($scope) ->
    $scope.visitEvent = (id) ->
      $state.go 'event', { id: id }

.filter 'decorateNumVolunteers', ->
  (num) ->
    if (num == 0)
      return 'None'
    num
