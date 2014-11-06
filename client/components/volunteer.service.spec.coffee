'use strict'

describe 'Volunteer service', ->

  # load the service's module
  beforeEach module 'farmersmarketApp'

  # instantiate service
  Volunteer = undefined

  beforeEach inject (_Volunteer_) ->
    Volunteer = _Volunteer_

  it 'should do something', ->
    expect(!!Volunteer).toBe true

  it 'should save a Volunteer', ->
    Volunteer.save { email: 'foo@bar', name: 'Foo', phone: '555-5555' }, (volunteer) ->
      expect(!!volunteer).toBe true
      expect(!!volunteer._id).toBe true
      expect(vollunteer.email).toBe 'foo@bar'
      expect(vollunteer.name).toBe 'Foo'
      expect(vollunteer.phone).toBe '555-5555'

  it 'should find a Volunteer by email', ->
    Volunteer.save { email: 'foo@bar', name: 'Foo', phone: '555-5555' }, (volunteer) ->
      expect(volunteer).toBe true

      Volunteer.query { email: 'foo@bar' }, (volunteers) ->
        expect(!!volunteers).toBe true
        expect(volunteers.length).toBe 1
        expect(vollunteers[0].email).toBe 'foo@bar'
        expect(vollunteers[0].name).toBe 'Foo'
        expect(vollunteers[0].phone).toBe '555-5555'

  it 'should not find a non-existent Volunteer', ->
    Volunteer.save { email: 'foo@bar', name: 'Foo', phone: '555-5555' }, (volunteer) ->
      expect(!!volunteer).toBe true

      Volunteer.query { email: 'bleh@baz' }, (volunteers) ->
        expect(!!volunteers).toBe true
        expect(volunteers.length).toBe 0
