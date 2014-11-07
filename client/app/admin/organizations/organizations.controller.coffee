'use strict'

m = angular.module 'farmersmarketApp'

m.controller 'AdminOrganizationsCtrl', ($scope, flash, Organization) ->
  $scope.errors = {}
  $scope.organizations = []
  $scope.organizationGridOptions = 
    data: 'organizations'
    sortInfo: { fields: ['name'], directions: ['asc'] }
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/organizations/name.cell.template.html'
        sortable: true
      }
      { field: 'email', displayName: 'Email', sortable: true }
      { field: 'phone', displayName: 'Phone', sortable: true }
      { field: 'active', displayName: 'Active', sortable: false }
    ]

  makeOrganizationItem = (organization) ->
    href: '/admin/organizations/' + organization._id
    name: organization.name
    email: organization.email
    phone: organization.phone
    active: organization.active

  Organization.query (organization) ->
    $scope.organizations = (makeOrganizationItem org for org in organization)
  , (headers) ->
    flash.error = headers.message

m.controller 'AdminOrganizationCtrl', ($scope, $location, $state, flash, dialogs, Organization) ->
  $scope.errors = {}
  $scope.actionTitle = 'New'
  _organization = null # the Organization instance from the server

  $scope.organization =
    id: 'new'
    name: ''
    about: ''
    email: ''
    phone: ''
    active: false
  $scope.masterOrganization = angular.copy($scope.organization)

  organizationId = $state.params['id']

  if (organizationId != 'new')
    $scope.actionTitle = 'Edit'
    Organization.get { id: organizationId }, (organization) ->
      _organization = organization
      $scope.organization =
        id: organization._id
        about: organization.about
        name: organization.name
        email: organization.email
        phone: organization.phone
        contact: organization.contact
        active: organization.active
      $scope.masterOrganization = angular.copy($scope.organization)

    , (headers) ->
      flash.error = headers.data.message

  $scope.isOrganizationChanged = (organization) ->
    !angular.equals(organization, $scope.masterOrganization)

  $scope.resetOrganization = ->
    $scope.organization = angular.copy($scope.masterOrganization)

  $scope.saveOrganization = (form) ->
    $scope.submitted = true

    if form.$valid
      if (organizationId == 'new')
        _organization = new Organization

      _organization.name = $scope.organization.name
      _organization.about = $scope.organization.about
      _organization.email = $scope.organization.email
      _organization.phone = $scope.organization.phone
      _organization.contact = $scope.organization.contact
      _organization.active = $scope.organization.active
        
      if (organizationId == 'new')
        _organization.$save (data, headers) ->
          flash.success = 'Create new Organization.'
          # $location.path('/admin/organizations')
          $state.go('admin-organizations')
        , (headers) ->
          flash.error = headers.message

      else
        _organization.$update (data, headers) ->
          flash.success = 'Modified organization details.'
          # $location.path('/admin/organizations')
          $state.go('admin-organizations')
        , (headers) ->
          flash.error = headers.message

  $scope.deleteOrganization = ->
    if $scope.organization.id == 'new' then return

    # FIXME Buttons are labelled "DIALOG_YES" and "DIALOG_NO".
    dlg = dialogs.confirm('Confirmation required', 'You are about to delete the organization \':name\'.'.replace(/:name/, $scope.organization.name))
    dlg.result.then (btn) ->
      _organization.$remove (err, data) ->
        $location.path('admin/organizations')
        # $state.go('admin-organizations') # Won't work from here.  Why?

    # , (btn) ->
    #   $scope.confirmed = 'You confirmed "No."'
