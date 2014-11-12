describe 'EventDecorator', ->
  event =
    _id: 'id_1'
    name: 'Event One'
    about: 'About Event One'
    organization: {  },
    start: new Date(2014, 6, 30, 12)
    end: new Date(2014, 6, 30, 13)
  EventDecorator = null
      
  beforeEach ->
    module('farmersmarketApp')

  beforeEach ->
    inject (_EventDecorator_) ->
      EventDecorator = _EventDecorator_
    
  it 'Should return a new object', ->
    decoratedEvent = EventDecorator.decorate(event)
    expect(decoratedEvent).not.toBe event

  it 'Should return result.date as a date string', ->
    decoratedEvent = EventDecorator.decorate(event)
    expect(decoratedEvent.date).toBe "Wed Jul 30 2014"

  it 'Should return result.starts as a time string', ->
    decoratedEvent = EventDecorator.decorate(event)
    expect(decoratedEvent.starts).toBe "noon"

  it 'Should return result.ends as a time string', ->
    decoratedEvent = EventDecorator.decorate(event)
    expect(decoratedEvent.ends).toBe "1pm"
