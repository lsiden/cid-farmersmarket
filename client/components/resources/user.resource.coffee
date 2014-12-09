'use strict'

angular.module 'farmersmarketApp'
.factory 'User', ($resource) ->
  $resource '/api/users/:id/:controller',
    { id: '@_id' }
  ,
    changeContactInfo:
      method: 'PUT'
      params:
        controller: 'contactInfo'

    changePassword:
      method: 'PUT'
      params:
        controller: 'password'
      
    resetPassword:
      method: 'PUT'
      params:
        controller: 'reset'

    update:
      method: 'PUT'
