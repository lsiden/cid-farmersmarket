'use strict'

describe 'Controller: RegisterVolunteerEventCtrl', ->

  # load the controller's module
  beforeEach module 'farmersmarketApp'

  # dependency placeholders
  RegisterVolunteerEventCtrl = undefined
  scope = undefined
  location = undefined
  state = undefined
  flash = undefined
  Event = undefined
  Volunteer = undefined
  VolunteerEvent = undefined

  eventId = 'event_123'
  path = '/volunteer/event/' + eventId + '/register'
  volunteer = {_id: 'volunteer_456' }
  volunteerEventParams = { volunteer: volunteer.id, event: eventId }

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, _$location_, _$state_, _flash_) ->

    class Event
      $save: ->
        {}
    Event.save = ->
      {}
    Event.get = ->
      {}

    class Volunteer
      $update: ->
        {}
      $save: ->
        {}
    Volunteer.save = ->
      {}
    Volunteer.query = ->
      []

    class VolunteerEvent
      $save: ->
        {}
    VolunteerEvent.save = ->
      {}
    VolunteerEvent.query = ->
      []
    sinon.stub VolunteerEvent, 'save'
    
    scope = $rootScope.$new()
    location = _$location_
    state = _$state_
    flash = _flash_

    state.params = { event_id: eventId }
    sinon.stub(location, 'path').returns(path)
    # sinon.stub Volunteer, 'save'
    # .yields volunteer

    RegisterVolunteerEventCtrl = $controller 'RegisterVolunteerEventCtrl',
      $scope: scope
      $location: location
      $state: state
      flash: flash
      Event: Event
      Volunteer: Volunteer
      VolunteerEvent: VolunteerEvent

    scope.volunteer.email = 'test@test.com'
    scope.volunteer.name = 'Test User'
    scope.volunteer.phone = '(555)-555-5555'

  it 'should register a new volunteer for event and save volunteer', ->

    # This volunteer has not previously registered for any event.
    sinon.stub Volunteer, 'query'
    .yields []

    # FIXME This will send the message 'undefined: undefined' to the console.
    # See https://github.com/cjohansen/Sinon.JS/issues/599
    # sinon.stub Volunteer.prototype, '$save'
    # .yields []
    
    scope.register()
    expect Volunteer.prototype.$save.calledOnce
    # expect Volunteer.prototype.$save.calledWithExactly scope.volunteer
    expect VolunteerEvent.save.calledWithExactly(volunteer._id, eventId)
    expect location.path.calledWithExactly 'volunteer/confirm'
    # TODO test that confirmation mail has been sent

  it 'should register a previous volunteer for event and update volunteer info', ->
    volunteer = sinon.stub 
      _id: 'volunteer_456'
      $update: ->

    # This volunteer has already registered for an event.
    sinon.stub Volunteer, 'query'
    .yields [ volunteer ]
    
    scope.register()
    expect volunteer.$update.calledWithExactly scope.volunteer
    expect VolunteerEvent.save.calledWithExactly volunteer._id, eventId
    expect location.path.calledWithExactly 'volunteer/confirm'
    # TODO test that confirmation mail has been sent

  it 'should not register a volunteer for the same event twice', ->
    volunteer = sinon.stub 
      _id: 'volunteer_456'
      $update: ->

    # This volunteer has already registered for an event.
    sinon.stub Volunteer, 'query'
    .yields [ volunteer ]

    # sinon.stub Volunteer, '$save'
    # .yields volunteer

    # This volunteer has already registered for this event.
    veParams = _.extend({}, volunteerEventParams, { createdAt: new Date() })

    sinon.stub VolunteerEvent, 'query'
    .yields [ veParams ]

    scope.register()
    expect(VolunteerEvent.save.callCount).toBe 0, 'attempt to register volunteer to same event twice'
    expect location.path.calledWithExactly 'volunteer/reconfirm'
    # TODO test that confirmation mail has not been sent
