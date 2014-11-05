'use strict'

angular.module 'farmersmarketApp'
.controller 'AccountsCtrl', ['$scope', '$http', 'flash', 'dialogs', 'User', 
($scope, $http, flash, dialogs, User) ->

  User.query (users) ->
    $scope.users = users.sort (_a, _b) ->
      a = _a.name
      b = _b.name
      if a < b then return -1
      if a > b then return 1
      return 0

  , (headers) ->
    flash.error = headers.data.message

  $scope.delete = (user) ->
    # FIXME Buttons are labelled "DIALOG_YES" and "DIALOG_NO".
    dlg = dialogs.confirm('Confirmation required', 'You are about to remove the account \':name\'.'.replace(/:name/, user.name))
    dlg.result.then (btn) ->
      user.$remove (err, data) ->
        _.remove $scope.users, user
      , (res) ->
        flash.error = 'Cannot remove this user now.'
]
