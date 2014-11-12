'use strict'

angular.module 'farmersmarketApp'
.controller 'LoginCtrl', ($scope, Auth, $location, $window, $state, $cookieStore) ->
  $scope.user = {}
  $scope.errors = {}
  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      # Logged in, redirect to home
      Auth.login
        email: $scope.user.email
        password: $scope.user.password

      .then ->
        state = $cookieStore.get 'after-login-state'
        
        if state
          $cookieStore.remove 'after-login-state'

          if angular.isArray state
            if state.length == 2
              $state.go state[0], state[1]
            else
              $state.go state[0]
          else
            $state.go state
        else
          $location.path '/'

      .catch (err) ->
        $scope.errors.other = err.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
