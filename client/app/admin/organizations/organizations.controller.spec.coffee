'use strict'

describe 'Controller: OrganizationsCtrl', ->

  # load the controller's module
  beforeEach module 'farmersmarketApp'
  OrganizationsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    OrganizationsCtrl = $controller 'OrganizationsCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
