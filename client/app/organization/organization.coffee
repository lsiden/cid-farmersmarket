'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider.state 'organization',
    url: '/organization/:id'
    templateUrl: 'app/organization/organization.html'
    controller: 'OrganizationCtrl'
