'use strict'

angular.module 'farmersmarketApp'
.config ($stateProvider) ->
  $stateProvider.state 'contact',
    url: '/contact'
    templateUrl: 'app/contact/contact.html'
    controller: 'ContactCtrl'
