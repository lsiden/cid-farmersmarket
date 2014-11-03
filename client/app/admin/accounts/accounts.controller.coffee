'use strict'

angular.module 'farmersmarketApp'
.controller 'AccountsCtrl', ['$scope', '$http', 'User', ($scope, $http, User) ->

  $http.get '/api/users'
  .success (users) ->
    $scope.users = users

  $scope.delete = (user) ->
    User.remove id: user._id
    _.remove $scope.users, user
]
