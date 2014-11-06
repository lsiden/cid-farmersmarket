'use strict'

describe 'Controller: VolunteerCtrl', ->

  # load the controller's module
  beforeEach module 'farmersmarketApp'

  # dependency placeholders
  VolunteerCtrl = undefined
  scope = undefined
  state = undefined
  location = undefined
  flash = undefined
  Event = undefined
  Volunteer = undefined
  VolunteerEvent = undefined

  eventId = 'event_123'
  eventPath = '/volunteer/event/' + eventId
  volunteer = {_id: 'volunteer_456' }
  volunteerEventParams = { volunteer: volunteer.id, event: eventId }

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, _$state_, _$location_, _flash_, _Event_, _Volunteer_, _VolunteerEvent_) ->
    
    scope = $rootScope.$new()
    state = _$state_
    location = _$location_
    flash = _flash_
    Event = _Event_
    Volunteer = _Volunteer_
    VolunteerEvent = _VolunteerEvent_

    sinon.stub(location, 'path').returns(eventPath)
    sinon.spy state, 'go'
    sinon.stub VolunteerEvent, 'save'
    sinon.stub Volunteer, 'save'
    .yields volunteer

    VolunteerCtrl = $controller 'VolunteerCtrl',
      $scope: scope
      $state: state
      $location: location
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
    
    scope.register()
    expect Volunteer.save.calledOnce
    expect Volunteer.save.calledWithExactly scope.volunteer
    expect VolunteerEvent.save.calledWithExactly(volunteer._id, eventId)
    expect state.go.calledWithExactly 'volunteer.confirm', volunteerEventParams
    # TODO test that confirmation mail has been sent

  it 'should register a previous volunteer for event and update volunteer info', ->
    volunteer = sinon.stub 
      id: 'volunteer_456'
      $update: ->

    # This volunteer has already registered for an event.
    sinon.stub Volunteer, 'query'
    .yields [ volunteer ]
    
    scope.register()
    expect volunteer.$update.calledWithExactly scope.volunteer
    expect VolunteerEvent.save.calledWithExactly volunteer._id, eventId
    expect state.go.calledWithExactly 'volunteer.confirm', volunteerEventParams
    # TODO test that confirmation mail has been sent

  it 'should not register a volunteer for the same event twice', ->
    volunteer = sinon.stub 
      id: 'volunteer_456'
      $update: ->

    # This volunteer has already registered for an event.
    sinon.stub Volunteer, 'query'
    .yields [ volunteer ]

    # This volunteer has already registered for this event.
    sinon.stub VolunteerEvent, 'query'
    .yields [ volunteerEventParams ]

    scope.register()
    expect(VolunteerEvent.save.callCount).toBe 0, 'attempt to register volunteer to same event twice'
    expect state.go.calledWithExactly 'volunteer.reconfirm', volunteerEventParams
    # TODO test that confirmation mail has not been sent
