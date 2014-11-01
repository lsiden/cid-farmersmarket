'use strict'

describe 'Event service', ->

  # load the service's module
  beforeEach module 'farmersmarketApp'

  # instantiate service
  event = undefined
  beforeEach inject (Event) ->
    event = Event

  it 'should do something', ->
    expect(!!event).toBe true
