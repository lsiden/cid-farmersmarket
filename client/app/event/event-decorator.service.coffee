angular.module 'farmersmarketApp'
.service 'EventDecorator', (DateDecorator) ->
  
  decorate: (_event) ->
    # console.log typeof(_event)
    if !_event
      throw 'EventDecorator.decorate(): null argument'
    
    if !_event._id
      _event = {
              _id: null
              name: ''
              about: ''
              organization: { name: '', contact: '', email: '', phone: ''},
              start: new Date()
              end: new Date()
      }
    event = angular.copy _event
    start = new Date(event.start)
    end = new Date(event.end)
    event.date = start.toDateString()
    event.starts = start.shortTime()
    event.ends = end.shortTime()
    event
