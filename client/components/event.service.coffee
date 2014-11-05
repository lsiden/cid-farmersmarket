'use strict'

angular.module 'farmersmarketApp'
.factory 'Event', ($resource) ->
  $resource '/api/events/:id/:controller', { id: '@_id' },

  update:
    method: 'PUT'
