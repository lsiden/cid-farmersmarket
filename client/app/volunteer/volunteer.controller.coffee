'use strict'

angular.module 'farmersmarketApp'
.controller 'VolunteerCtrl', ($scope, $state, flash, Volunteer) ->
  $scope.volunteer = {}
  $scope.message = ''
  id = $state.params.id
  
  if id && id != 'new'
    Volunteer.get { id: $state.params.id }, (volunteer) ->
      $scope.volunteer.name = volunteer.name
      $scope.volunteer.phone = volunteer.phone
      $scope.volunteer.email = volunteer.email

      $scope.masterVolunteer = angular.copy($scope.volunteer)
    , (headers) ->
      flash.error = headers.data.message
  else if $state.params.email
    $scope.volunteer.email = $state.params.email

  $scope.isFormChanged = (volunteer) ->
    !angular.equals(volunteer, $scope.masterVolunteer)

  $scope.resetForm = ->
    $scope.volunteer = angular.copy($scope.masterVolunteer)
  
  $scope.saveVolunteer = (form) ->
    $scope.submitted = true

    if form.$valid
      volunteer = new Volunteer()
      volunteer.name = $scope.volunteer.name
      volunteer.phone = $scope.volunteer.phone
      volunteer.email = $scope.volunteer.email
      volunteer.$save (data, headers) ->
        # $scope.message = 'Content info successfully changed.'
        flash.success = 'Congratulations!  You are now registered.'
        $state.go('main')
      , (res) ->
        # $scope.message = 'Cannot update your contact info now.'
        flash.error = headers.message

angular.module 'farmersmarketApp'
.directive 'editVolunteerInfo', ->
  restrict: 'E'
  scope: true # inherit parent scope
  templateUrl: 'app/volunteer/volunteer-info-form.html'
