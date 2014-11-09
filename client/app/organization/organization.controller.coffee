'use strict'

angular.module 'farmersmarketApp'
.controller 'OrganizationCtrl', ($scope, $state, Organization) ->
  $scope.organization = {}

  Organization.get { id: $state.params.id }, (org) ->
    $scope.organization.name = org.name
    $scope.organization.about = org.about
    $scope.organization.contact = org.contact
    $scope.organization.phone = org.phone
    $scope.organization.email = org.email
    $scope.organization.url = org.url
