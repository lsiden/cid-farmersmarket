'use strict'

describe 'Controller: EventsCtrl', ->

  # load the controller's module
  beforeEach module 'farmersmarketApp'
  EventsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    EventsCtrl = $controller 'EventsCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
