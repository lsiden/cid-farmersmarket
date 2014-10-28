'use strict'

angular.module 'farmersmarketApp'
.controller 'SettingsCtrl', ($scope, $http, User, Auth) ->
  $scope.errors = {}
  $scope.fields = ['name', 'email', 'phone']

  #$http.get('/api/users/me').success (user) ->
  User.get (user) ->
    $scope.uid = user._id
    $scope.contactInfo = {
      name: user.name
      email: user.email
      phone: user.phone
    }
  
  $scope.changeContactInfo = (form) ->
    $scope.submitted = true

    if form.$valid
      User.changeContactInfo { id: $scope.uid}, $scope.contactInfo, ->
        $scope.message = 'Content info successfully changed.'

  $scope.changePassword = (form) ->
    $scope.submitted = true

    if form.$valid
      Auth.changePassword $scope.user.oldPassword, $scope.user.newPassword
      .then ->
        $scope.message = 'Password successfully changed.'

      .catch ->
        form.password.$setValidity 'mongoose', false
        $scope.errors.other = 'Incorrect password'
        $scope.message = ''

  $scope.capitalize = (s) ->
    s[0].toUpperCase() + s.slice(1)
