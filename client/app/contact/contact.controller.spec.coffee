'use strict'

describe 'Controller: ContactCtrl', ->

  # load the controller's module
  beforeEach module 'farmersmarketApp'
  ContactCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ContactCtrl = $controller 'ContactCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
