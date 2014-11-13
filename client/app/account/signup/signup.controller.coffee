'use strict'

# TODO add password confirmation input ('Retype password')

angular.module 'farmersmarketApp'
.controller 'SignupCtrl', ($scope, Auth, $state, $location, $window, eventService) ->
  $scope.user = {}
  $scope.errors = {}
  $scope.register = (form) ->
    $scope.submitted = true
    return unless form.$valid

    # Account created, redirect to home
    Auth.createUser
      name: $scope.user.name
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
      err = err.data
      $scope.errors = {}

      # Update validity of form fields that match the mongoose errors
      angular.forEach err.errors, (error, field) ->
        form[field].$setValidity 'mongoose', false
        $scope.errors[field] = error.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
