'use strict'

angular.module 'farmersmarketApp'
.factory 'Event', ($resource) ->
  $resource '/api/events/:id/:controller',
  null
  ,
  get:
    method: 'GET'
    isArray: true

  post:
    method: 'POST'
    
  put:
    method: 'PUT'
