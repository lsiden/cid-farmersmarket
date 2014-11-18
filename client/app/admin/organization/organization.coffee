'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->

  $stateProvider.state 'admin-organization',
    url: '/admin/organizations/:id'
    templateUrl: 'app/admin/organization/organization.html'
    controller: 'AdminOrganizationsCtrl'
    authenticate: true

  $stateProvider.state 'admin-organizations',
    url: '/admin/organizations'
    templateUrl: 'app/admin/organization/index/organizations.html'
    controller: 'AdminOrganizationsCtrl'
    authenticate: true
