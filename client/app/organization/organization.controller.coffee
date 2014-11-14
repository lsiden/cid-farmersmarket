'use strict'

angular.module 'farmersmarketApp'
.controller 'OrganizationCtrl', ($scope, $state, Organization) ->
  $scope.organization = Organization.get { id: $state.params.id }
