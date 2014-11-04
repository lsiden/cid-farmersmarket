'use strict'

describe 'Controller: VolunteerCtrl', ->

  # load the controller's module
  beforeEach module 'farmersmarketApp'
  VolunteerCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    VolunteerCtrl = $controller 'VolunteerCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
