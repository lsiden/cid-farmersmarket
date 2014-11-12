describe 'eventService', ->
  $q = null
  $rootScope = null

  event =
    _id: 'id_1'
    name: 'Event One'
    about: 'About Event One'
    organization: {  },
    start: new Date(2014, 6, 30, 12)
    end: new Date(2014, 6, 30, 13)
  eventService = null
      
  beforeEach ->
    module('farmersmarketApp')

  beforeEach ->
    inject (_$rootScope_, _$q_, _eventService_) ->
      $rootScope = _$rootScope_
      $q = _$q_
      eventService = _eventService_
      event.$promise = $q.defer().promise

  it 'Should return the same object', ->
    decoratedEvent = eventService.decorate(event)
    expect(decoratedEvent).toBe event

  it 'Should return result.date as a date string', ->
    eventService.decorate(event).$promise.then (event) ->
      expect(decoratedEvent.date).toBe "Wed Jul 30 2014"

  it 'Should return result.starts as a time string', ->
    eventService.decorate(event).$promise.then (event) ->
      expect(decoratedEvent.starts).toBe "noon"

  it 'Should return result.ends as a time string', ->
    eventService.decorate(event).$promise.then (event) ->
      expect(decoratedEvent.ends).toBe "1pm"
