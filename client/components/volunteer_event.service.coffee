'use strict'

angular.module 'farmersmarketApp'
.factory 'VolunteerEvent', ($resource) ->
  $resource '/api/volunteer_events/:id/:controller', { id: '@_id' }
  , findOrCreate:
    method: 'POST'
    params:
      controller: 'findOrCreate'
