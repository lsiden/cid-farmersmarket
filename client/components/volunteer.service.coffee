'use strict'

angular.module 'farmersmarketApp'
.factory 'Volunteer', ($resource) ->
  $resource '/api/volunteers/:id/:controller', { id: '@_id' },

  update:
    method: 'PUT'
