'use strict'

angular.module 'farmersmarketApp'
.controller 'NavbarCtrl', ($scope, $location, $modal, $state, flash, Auth, User) ->
  $scope.menu = [
    { title: 'Home', link: '/'}
    # { title: 'Register', link: '/volunteer/new' }
  ]
  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser

  $scope.logout = ->
    Auth.logout()
    $location.path '/login'

  $scope.isActive = (route) ->
    route is $location.path()

  # Most of the above was generated.
  # Add new logic below.

  # $scope.inputEmailDlg = ->
  #   # dialogs.create 'assets/input_email_dlg.html', 'customDialogCtrl', {},
  #   $modal.open
  #     templateUrl: '/assets/input_email_dlg.html'
  #     controller: 'inputEmailDlgCtrl'
  #   .result.then (email) ->
  #     User.query { email: email }, (volunteers) ->
  #       if (volunteers && volunteers.length)
  #         $state.go 'volunteer', { id: volunteers[0]._id }
  #       else
  #         $state.go 'volunteer', { id: 'new', email: email }
  #     , (headers) ->
  #       flash.error = headers.message
