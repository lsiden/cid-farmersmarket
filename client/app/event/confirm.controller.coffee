'use strict'

angular.module 'farmersmarketApp'
.controller 'ConfirmCtrl', ($scope, $state, flash, Event, EventDecorator) ->
  # Expecting $state.params = { id: ... }

  $scope.errors = {}
  $scope.event = EventDecorator.decorate {}
  $scope.registeredDate = null
  $scope.registeredTime = null

  sdate = $state.params.confirmed
  # console.log(sdate)
  
  if sdate
    date = new Date(sdate)
    $scope.registeredDate = date.toDateString()
    $scope.registeredTime = date.shortTime()

  # console.log $state.params
  Event.get id: $state.params.id, (event) ->
    $scope.event = EventDecorator.decorate event
  , (err) ->
    flash.error = err
