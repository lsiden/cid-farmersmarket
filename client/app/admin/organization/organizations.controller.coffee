'use strict'

m = angular.module 'farmersmarketApp'

m.controller 'AdminOrganizationsCtrl', ($scope, $state, flash, Organization) ->
  
  $scope.new = ->
    console.log('new()')
    Organization.save (org) ->
      $state.go 'admin-organization', { id: org._id }

  $scope.errors = {}
  $scope.organizations = Organization.query()
  $scope.organizationGridOptions = 
    data: 'organizations'
    enableRowSelection: false
    enableCellSelection: false
    sortInfo: { fields: ['name'], directions: ['asc'] }
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/organization/index/name.cell.template.html'
        sortable: true
      }
      {
        field: 'email'
        displayName: 'Email'
        cellTemplate: 'app/admin/organization/index/email.cell.template.html'
        sortable: false
      }
      { field: 'phone', displayName: 'Phone', sortable: false }
      { field: 'active', displayName: 'Active', sortable: false }
    ]

m.controller 'AdminOrganizationCtrl', ($scope, $state, flash, Modal, Organization) ->
  $scope.errors = {}
  orgId = $state.params['id']

  if (orgId != 'new')
    $scope.actionTitle = 'Edit'
    $scope.organization = Organization.get { id: orgId }, (organization) ->
      $scope.masterOrganization = angular.copy($scope.organization)
    , (headers) ->
      flash.error = headers.message
    $scope.masterOrganization = angular.copy($scope.organization)
  else
    $scope.actionTitle = 'New'
    $scope.organization = new Organization
    $scope.masterOrganization = angular.copy($scope.organization)

  $scope.isOrganizationChanged = (organization) ->
    !angular.equals(organization, $scope.masterOrganization)

  $scope.resetOrganization = ->
    $scope.organization = angular.copy($scope.masterOrganization)

  $scope.saveOrganization = (form) ->
    $scope.submitted = true
    
    return if !form.$valid

    if (organizationId == 'new')
      $scope.organization.$save (data, headers) ->
        flash.success = 'Create new Organization.'
        $state.go('admin-organizations')
      , (headers) ->
        flash.error = headers.message
    else
      $scope.organization.$update (data, headers) ->
        flash.success = 'Modified organization details.'
        $state.go('admin-organizations')
      , (headers) ->
        flash.error = headers.message

  $scope.deleteOrganization = ->
    org = $scope.organization
    return if org._id == 'new'

    del = ->
      org.$remove ->
        _.remove $scope.users, org
        $state.go 'admin-organizations'
      , (headers) ->
        flash.error = headers.message
    
    Modal.confirm.delete(del) org.name
