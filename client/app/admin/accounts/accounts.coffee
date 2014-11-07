'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider.state 'admin-accounts',
    url: '/admin/accounts'
    templateUrl: 'app/admin/accounts/accounts.html'
    controller: 'AccountsCtrl'
    authenticate: true
