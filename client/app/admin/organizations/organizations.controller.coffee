'use strict'

m = angular.module 'farmersmarketApp'

m.controller 'AdminOrganizationsCtrl', ($scope, flash, Organization) ->
  $scope.errors = {}
  $scope.organizations = []
  $scope.organizationGridOptions = 
    data: 'organizations'
    enableRowSelection: false
    enableCellSelection: false
    sortInfo: { fields: ['name'], directions: ['asc'] }
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/organizations/name.cell.template.html'
        sortable: true
      }
      {
        field: 'email'
        displayName: 'Email'
        cellTemplate: 'app/admin/organizations/email.cell.template.html'
        sortable: true
      }
      { field: 'phone', displayName: 'Phone', sortable: true }
      { field: 'active', displayName: 'Active', sortable: false }
    ]

  $scope.organizations = Organization.query (organization)

m.controller 'AdminOrganizationCtrl', ($scope, $location, $state, flash, dialogs, Organization) ->
  $scope.errors = {}
  orgId = $state.params['id']

  if (orgId != 'new')
    $scope.actionTitle = 'Edit'
    $scope.organization = Organization.get { id: orgId }, (organization) ->
      $scope.masterOrganization = angular.copy($scope.organization)
    , (headers) ->
      flash.error = headers.data.message
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
        # $location.path('/admin/organizations')
        $state.go('admin-organizations')
      , (headers) ->
        flash.error = headers.message
    else
      $scope.organization.$update (data, headers) ->
        flash.success = 'Modified organization details.'
        # $location.path('/admin/organizations')
        $state.go('admin-organizations')
      , (headers) ->
        flash.error = headers.message

  $scope.deleteOrganization = ->
    return if $scope.organization._id == 'new'

    # FIXME Buttons are labelled "DIALOG_YES" and "DIALOG_NO".
    dlg = dialogs.confirm('Confirmation required', 'You are about to delete the organization \':name\'.'.replace(/:name/, $scope.organization.name))
    dlg.result.then (btn) ->
      _organization.$remove (err, data) ->
        $location.path('admin/organizations')
        # $state.go('admin-organizations') # Won't work from here.  Why?

    # , (btn) ->
    #   $scope.confirmed = 'You confirmed "No."'
