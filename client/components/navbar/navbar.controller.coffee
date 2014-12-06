'use strict'

angular.module 'farmersmarketApp'
.controller 'NavbarCtrl', ($scope, $location, $modal, $state, flash, Auth, User) ->
  $scope.menu = [
    { title: 'About', state: 'about' }
    { title: 'Contact', state: 'contact' }
  ]
  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser

  $scope.logout = ->
    Auth.logout()
    # $location.path '/login'
    $location.path '/'

  $scope.isActive = (route) ->
    route is $location.path()

  # Most of the above was generated.
  # Add new logic below.
