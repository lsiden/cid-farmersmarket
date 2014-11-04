'use strict'

angular.module 'farmersmarketApp'
.controller 'AccountsCtrl', ['$scope', '$http', 'User', ($scope, $http, User) ->

  User.query (users) ->
    $scope.users = users

  $scope.delete = (user) ->
    User.remove id: user._id
    _.remove $scope.users, user
]
