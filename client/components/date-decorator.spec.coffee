describe 'DateDecorator', ->
  DateDecorator = null

  beforeEach ->
    module('farmersmarketApp')

  beforeEach ->
    inject (_DateDecorator_) ->
      DateDecorator = _DateDecorator_
    
  it 'Date should have an addDays() method', ->
    expect(Date.addDays).toBeTruthy
    d = new Date
    d2 = new Date(d)
    d2.addDays(2)
    expect(d2-d).toBe 48*3600*1000
    
  it 'Date should have an addHours() method', ->
    expect(Date.addHours).toBeTruthy
    d = new Date
    d2 = new Date(d)
    d2.addHours(2)
    expect(d2-d).toBe 2*3600*1000
    
  it 'Date should have an shortTime() method', ->
    expect(Date.shortTime).toBeTruthy
    d = new Date(2012, 6, 30, 12)
    expect(d.shortTime()).toBe 'noon'
    
  it 'Date should have a toYmd() method', ->
    expect(Date.toYmd).toBeTruthy
    d = new Date(2014, 5, 30, 12, 30)
    expect(d.toYmd()).toBe '2014-06-30'
