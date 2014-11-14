'use strict'

angular.module 'farmersmarketApp'
.controller 'AccountCtrl', ($scope, flash, Auth, User) ->

  $scope.resetPassword = ->
    flash.warning = 'To be implemented by developer.' # TODO

  $scope.user = Auth.getCurrentUser()
  $scope.roles = [
    { name: 'Admin', id: 'admin' }
    { name: 'User', id: 'user' }
  ]
