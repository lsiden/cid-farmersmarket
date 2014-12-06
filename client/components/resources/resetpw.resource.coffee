'use strict'

angular.module 'farmersmarketApp'
.factory 'ResetPwApi', ['$resource', ($resource) ->
  $resource '/api/resetpw/:key', {},

  save:
    method: 'POST'

  reset:
    method: 'GET'
]
