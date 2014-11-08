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

  it 'should save a Volunteer', (done) ->
    Volunteer.save { email: 'foo@bar', name: 'Foo', phone: '555-5555' }, (volunteer) ->
      expect(!!volunteer).toBe true
      expect(!!volunteer._id).toBe true
      expect(volunteer.email).toBe 'foo@bar'
      expect(volunteer.name).toBe 'Foo'
      expect(volunteer.phone).toBe '555-5555'
      done()

  it 'should find a Volunteer by email', (done) ->
    Volunteer.save { email: 'foo@bar', name: 'Foo', phone: '555-5555' }, (volunteer) ->
      expect(volunteer).toBe true

      Volunteer.query { email: 'foo@bar' }, (volunteers) ->
        expect(!!volunteers).toBe true
        expect(volunteers.length).toBe 1
        expect(volunteers[0].email).toBe 'foo@bar'
        expect(volunteers[0].name).toBe 'Foo'
        expect(volunteers[0].phone).toBe '555-5555'
        done()

  it 'should not find a different Volunteer', (done) ->
    Volunteer.save { email: 'foo@bar', name: 'Foo', phone: '555-5555' }, (volunteer) ->
      expect(!!volunteer).toBe true

      Volunteer.query { email: 'bleh@baz' }, (volunteers) ->
        expect(!!volunteers).toBe true
        expect(volunteers.length).toBe 0
        done()

  it 'should create a new volunteer with save()', (done) ->
    Volunteer.save { email: 'foo@bar', name: 'Foo', phone: '555-5555'}, (volunteer) ->
      expect(!!volunteer).toBe true
      expect(!!volunteer._id).toBe true
      expect(volunteer.email).toBe 'foo@bar'
      expect(volunteer.name).toBe 'Foo'
      expect(volunteer.phone).toBe '555-5555'
      done()

  it 'should update an existing volunteer with save()', (done) ->
    Volunteer.save { email: 'foo@bar', name: 'Foo', phone: '555-5555'}, (volunteer) ->
      expect(!!volunteer).toBe true
      expect(!!volunteer._id).toBe true
      expect(volunteer.email).toBe 'foo@bar'
      expect(volunteer.name).toBe 'Foo'
      expect(volunteer.phone).toBe '555-5555'
      
      Volunteer.save { email: 'foo@bar', name: 'Bar', phone: '777-7777'}, (volunteer) ->
        expect(!!volunteer).toBe true
        expect(!!volunteer._id).toBe true
        expect(volunteer.email).toBe 'foo@bar'
        expect(volunteer.name).toBe 'Bar'
        expect(volunteer.phone).toBe '777-7777'
        done()
