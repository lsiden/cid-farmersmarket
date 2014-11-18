'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider.state 'admin-accounts',
    url: '/admin/accounts'
    templateUrl: 'app/admin/account/index/accounts.html'
    controller: 'AccountsCtrl'
    authenticate: true

  $stateProvider.state 'admin-account',
    url: '/admin/account/:id'
    templateUrl: 'app/admin/account/account.html'
    controller: 'AccountCtrl'
    authenticate: true
