'use strict'

angular.module 'farmersmarketApp'
.factory 'User', ($resource) ->
  $resource '/api/users/:id/:controller',
    id: '@_id'
  ,
    changeContactInfo:
      method: 'PUT'
      params:
        controller: 'contactInfo'

    changePassword:
      method: 'PUT'
      params:
        controller: 'password'

    get:
      method: 'GET'
      params:
        id: 'me'

    lookup:
      method: 'GET'

