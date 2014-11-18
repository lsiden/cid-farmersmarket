'use strict'

angular.module 'farmersmarketApp'
.controller 'AccountCtrl', ($scope, $state, flash, Auth, User) ->
  $scope.submitted = false
  $scope.errors = {}
  $scope.user_master = {}
  $scope.user = User.get { id: $state.params.id }, (user) ->
    $scope.user_master = angular.copy(user)

  $scope.reset = (form) ->
    $scope.user = angular.copy($scope.user_master)

  $scope.submit = (form) ->
    $scope.submitted = true
    return unless form.$valid

    $scope.user.$update (user) ->
      flash.success = 'Updated account ' + user.email
      $state.go('admin-accounts')
    , (headers) ->
      flash.error = headers.message

  $scope.isUserChanged = ->
    !angular.equals($scope.user, $scope.user_master)

  $scope.roles = [
    { name: 'Admin', _id: 'admin' }
    { name: 'User', _id: 'user' }
    { name: 'User2', _id: 'user2' }
  ]

  $scope.resetPassword = ->
    flash.error = 'not yet implemented'
