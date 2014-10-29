'use strict'

angular.module 'farmersmarketApp'
.controller 'ContactInfoCtrl', ['$scope', '$http', 'User', ($scope, $http, User) ->
  $scope.errors = {}
  $scope.contactInfo = {}

  # ng-pattern won't work together with ui-mask and isn't needed.
  #$scope.phonePat = /^\(\d{3}\) \d{3}-\d{4}$/

  #$http.get('/api/users/me').success (user) ->
  User.get (user) ->
    $scope.uid = user._id
    $scope.contactInfo = {
      name: user.name
      email: user.email
      phone: user.phone
    }
    $scope.masterContactInfo = angular.copy($scope.contactInfo)

  $scope.isContactInfoChanged = (contactInfo) ->
    !angular.equals(contactInfo, $scope.masterContactInfo)

  $scope.resetContactInfo = ->
    $scope.contactInfo = angular.copy($scope.masterContactInfo)
  
  $scope.changeContactInfo = (form) ->
    $scope.submitted = true

    if form.$valid
      User.changeContactInfo { id: $scope.uid}, $scope.contactInfo, (data, header) ->
        $scope.message = 'Content info successfully changed.'
      , (res) ->
        $scope.message = 'Cannot update your contact info now.'
  ]

.controller 'ChangePasswordCtrl', ['$scope', '$http', 'Auth', ($scope, $http, Auth) ->
  $scope.errors = {}
  $scope.pw = {}

  $scope.changePassword = (form) ->
    $scope.submitted = true

    if form.$valid
      Auth.changePassword $scope.pw.oldPassword, $scope.pw.newPassword
      .then ->
        $scope.message = 'Password successfully changed.'

      .catch ->
        form.password.$setValidity 'mongoose', false
        $scope.errors.other = 'Incorrect password'
        $scope.message = ''

  $scope.clearPassword = (form) ->
    $scope.pw.oldPassword = ''
    $scope.pw.newPassword = ''
    $scope.pw.retypePassword = ''
    form.$setPristine()
    form.$setValid()

.directive 'matchPassword', ->
  {
    require: 'ngModel'
    controller: 'ChangePasswordCtrl'
    link: (scope, el, attrs, model) ->
      model.$validators.matchPassword = (modelValue, viewValue) ->
        modelValue == scope.pw.newPassword
  }
