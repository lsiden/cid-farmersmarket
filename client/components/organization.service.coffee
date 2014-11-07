'use strict'

angular.module 'farmersmarketApp'
.factory 'Organization', ($resource) ->
  $resource '/api/organizations/:id/:controller', { id: '@_id' },

  update:
    method: 'PUT'
