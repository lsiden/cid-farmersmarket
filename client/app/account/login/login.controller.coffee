'use strict'

angular.module 'farmersmarketApp'
.controller 'LoginCtrl', ($scope, Auth, $window, $state, eventService) ->
  $scope.user = {}
  $scope.errors = {}
  $scope.login = (form) ->
    $scope.submitted = true
    return unless form.$valid

    Auth.login
      email: $scope.user.email
      password: $scope.user.password
    .then ->
      event_id = eventService.registerAfterLogin()
      
      if event_id
        # User was redirected here after attempting to volunteer,
        # so we satisfy his intent.
        eventService.registerAfterLogin(null) # clear it
        eventService.registerVolunteer(event_id)
      $state.go 'main'
    .catch (err) ->
      $scope.errors.other = err.message
      flash.error = err.message


  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
