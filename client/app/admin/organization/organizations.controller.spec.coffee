'use strict'

describe 'Controller: AdminOrganizationsCtrl', ->

  # load the controller's module
  beforeEach module 'farmersmarketApp'
  OrganizationsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    OrganizationsCtrl = $controller 'AdminOrganizationsCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
