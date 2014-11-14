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

  $scope.accountGridOptions = 
    data: 'users'
    enableRowSelection: false
    enableCellSelection: false
    sortInfo: { fields: ['name'], directions: ['asc'] }
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/accounts/name.cell.template.html'
        sortable: true
      }
      {
        field: 'role'
        displayName: 'Role'
        sortable: true
      }
      {
        field: 'email'
        displayName: 'Email'
        cellTemplate: 'app/admin/accounts/email.cell.template.html'
        sortable: false
      }
      { field: 'phone', displayName: 'Phone', sortable: false }
      { field: 'active', displayName: 'Active', sortable: true }
    ]
