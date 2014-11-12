'use strict'

describe 'Controller: EventCtrl', ->

  # load the controller's module
  beforeEach module 'farmersmarketApp'
  EventCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    EventCtrl = $controller 'EventCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
