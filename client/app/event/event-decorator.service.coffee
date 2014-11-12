angular.module 'farmersmarketApp'
.service 'EventDecorator', (DateDecorator) ->
  
  decorate: (event) ->
    # console.log typeof(event)
    if !event
      throw 'EventDecorator.decorate(): null argument'

    event.$promise.then (_event) ->
      start = new Date(event.start)
      end = new Date(event.end)
      event.date = start.toDateString()
      event.starts = start.shortTime()
      event.ends = end.shortTime()
  
    event
