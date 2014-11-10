'use strict'

angular.module 'farmersmarketApp'
.controller 'VolunteerCtrl', ($scope, $state, flash, Volunteer) ->
  $scope.volunteer = {}
  $scope.masterVolunteer = {}
  $scope.message = ''
  
  id = $state.params.id
  _volunteer = new Volunteer() # from server
  
  if id && id != 'new'
    Volunteer.get { id: $state.params.id }, (volunteer) ->
      _volunteer = volunteer
      $scope.volunteer.name = volunteer.name
      $scope.volunteer.phone = volunteer.phone
      $scope.volunteer.email = volunteer.email
      $scope.masterVolunteer = angular.copy($scope.volunteer)
    , (headers) ->
      flash.error = headers.data.message
  else
    $scope.volunteer.email = $state.params.email

  $scope.isFormChanged = (volunteer) ->
    !angular.equals(volunteer, $scope.masterVolunteer)

  $scope.resetForm = ->
    $scope.volunteer = angular.copy($scope.masterVolunteer)
  
  $scope.saveVolunteer = (form) ->
    # $scope.submitted = true

    if !form.$valid
      return
    _volunteer.name = $scope.volunteer.name
    _volunteer.phone = $scope.volunteer.phone
    _volunteer.email = $scope.volunteer.email

    if id && id != 'new'
      _volunteer.$update (data, headers) ->
        # $scope.message = 'Content info successfully changed.'
        flash.success = 'Thank you for updating your contact info.'
        $state.go('main')
      , (headers) ->
        # $scope.message = 'Cannot update your contact info now.'
        flash.error = headers.message
    else
      _volunteer.$save (data, headers) ->
        # $scope.message = 'Content info successfully changed.'
        flash.success = 'Congratulations!  You are now registered.'
        $state.go('main')
      , (headers) ->
        # $scope.message = 'Cannot update your contact info now.'
        flash.error = headers.message

angular.module 'farmersmarketApp'
.directive 'editVolunteerInfo', ->
  restrict: 'E'
  scope: true # inherit parent scope
  templateUrl: 'app/volunteer/volunteer-info-form.html'
