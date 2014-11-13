'use strict'

angular.module 'farmersmarketApp'
.controller 'AccountsCtrl', ($scope, flash, Modal, User) ->

  $scope.users = User.query (users) ->
    $scope.users.sort (a, b) ->
      return 0 if a.name == b.name
      return 1 if a.name > b.name
      return -1
  , (headers) ->
    flash.error = headers.message

  $scope.delete = (user) ->
    del = ->
      user.$remove ->
        _.remove $scope.users, user
      , (headers) ->
        flash.error = headers.message
    
    Modal.confirm.delete(del) user.name
