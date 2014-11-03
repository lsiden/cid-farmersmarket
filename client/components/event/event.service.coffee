'use strict'

angular.module 'farmersmarketApp'
.factory 'Event', ($resource) ->
  $resource '/api/events/:id/:controller',
    #id: '@_id'
  null
  ,
  get:
    method: 'GET'
    isArray: true

  put:
    method: 'PUT'
