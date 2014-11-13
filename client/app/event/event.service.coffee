angular.module 'farmersmarketApp'
.factory 'eventService', (Auth, $cookieStore, $state, $q, VolunteerEvent, Event, flash) ->
  
  # Date.prototype.addDays() not available during unit testing.
  today = new Date()
  yesterday = today.setDate(today.getDate() + -1); # Date.addDays wasn't defined in testing

  self =
    # Return by promise all active events that haven't ended.
    # Add optional params to query, if given.
    currentEvents: (params) ->
      params || = {}
      params.end = '>' + yesterday
      # console.log(params);
      Event.query params

    # Return by promise all active events that have ended.
    # Add optional params to query, if given.
    pastEvents: (params) ->
      params || = {}
      params.end = '<' + today
      # console.log(params);
      Event.query params

    registerVolunteer: (event_id) ->
      # If volunteer is not yet authenticated, remember his intent and redirect him to /login.
      Auth.isLoggedInAsync (is_loggedIn) ->
        if !is_loggedIn
          self.registerAfterLogin event_id
          $state.go('login')
          return

        params = { volunteer: Auth.getCurrentUser()._id, event: event_id } # query params

        VolunteerEvent.query params, (volunteerEvents) ->
          if volunteerEvents.length == 0
            volunteerEvent = new VolunteerEvent(params)
            volunteerEvent.$save (data, headers) ->
              flash.success = 'Thank you for volunteering! Please check your e-mail for confirmation.'
            , (headers) ->
              flash.error = headers.message
          else
            flash.success = 'You have already volunteered for this event.  Thank you.'

    # Returns hash of events that user is registered for.
    # Will be completed by return_val.promise
    registeredByVolunteer: (user) ->
      registeredEvents = {}
      registeredEvents.promise = $q.defer()
      user.$promise ||= $q.when(user)
        
      user.$promise.then (user) ->
        if !Auth.isLoggedIn()
          return registeredEvents.promise.resolve registeredEvents
          
        VolunteerEvent.query { volunteer: user._id }, (volunteerEvents) ->
          for ve in volunteerEvents
            do (ve) ->
              registeredEvents[ve.event._id] = ve.event
          registeredEvents.promise.resolve registeredEvents
        , (headers) ->
          registeredEvents.promise.reject headers.message
      , (headers) ->
        registeredEvents.promise.reject headers.message

      registeredEvents

    # Return event id that user tried to register for
    # before being redirected to /login page.
    # fn() gets, fn(val) sets, and fn(null) clears the value.
    registerAfterLogin: ->
      key = 'after-login-register-event'

      if arguments.length > 0
        if arguments[0]
          $cookieStore.put key, arguments[0]
        else
          $cookieStore.remove key
      else
        $cookieStore.get key
  
    # Add .date, .starts, and .ends to event for views
    decorate: (event) ->
      # console.log typeof(event)
      if !event
        throw 'eventService.decorate(): null argument'

      event.$promise ||= $q.when(event)
      event.$promise.then (event) ->
        start = new Date(event.start)
        end = new Date(event.end)
        event.date = start.toDateString()
        event.starts = start.shortTime()
        event.ends = end.shortTime()
        event.hours = '' + start.shortTime() + ' to ' + end.shortTime()
        attendance: '' + event.volunteers + '/' + event.volunteerSlots
      event

    visitEvent: (event_id) ->
      $state.go('event', { id: event_id })

  return self
