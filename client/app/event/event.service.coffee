'use strict'

angular.module 'farmersmarketApp'
.factory 'eventService', (Auth, $cookieStore, $state, $q, Modal, VolunteerEvent, Event, flash) ->
  
  today = new Date()

  self =
    # Return by promise all active events that haven't ended.
    # Add optional params to query, if given.
    currentEvents: (params, callback) ->
      params || = {}
      params.from = today.toISOString().substr(0, 10)
      # console.log(params);
      callback ||= ->
      Event.query params, callback

    # Return by promise all active events that have ended.
    # Add optional params to query, if given.
    pastEvents: (params, callback) ->
      params || = {}
      params.thru = today.toISOString().substr(0, 10)
      # console.log(params);
      callback ||= ->
      Event.query params, callback

    registerVolunteer: (event_id, callback) ->
      # If volunteer is not yet authenticated, remember his intent and redirect him to /login.
      Auth.isLoggedInAsync (isLoggedIn) ->
        if !isLoggedIn
          self.registerAfterLogin event_id
          return $state.go('login')

        params = { volunteer: Auth.getCurrentUser()._id, event: event_id } # query params

        VolunteerEvent.query params, (volunteerEvents) ->
          if volunteerEvents.length > 0
            flash.success = 'You have already volunteered for this event.  Thank you.'
            $state.go('event', { id: event_id })
            return callback?(true)
            
          volunteerEvent = new VolunteerEvent(params)
          volunteerEvent.$save (data, headers) ->
            callback?(true)
            flash.success = 'Thank you for volunteering! Please check your e-mail for confirmation.'
            $state.go('event', { id: event_id })
          , (headers) ->
            callback?(false)
            flash.error = headers.message

    unregisterVolunteer: (event_id, callback) ->
      # Volunteer must already be authenticated.
      if !Auth.isLoggedIn
        return $state.go('login')

      params = { volunteer: Auth.getCurrentUser()._id, event: event_id } # query params

      VolunteerEvent.query params, (volunteerEvents) ->
        if volunteerEvents.length == 0
          flash.success = 'You were not registered for this event. No further action is needed.'
          $state.go('event', { id: event_id })
          return callback?(true)
          
        # There should be only one instance, but we'll iterate just for good form.
        for v in volunteerEvents
          v.$delete (data, headers) ->
            callback?(true)
            flash.success = 'You have successfully cancelled your registration to this event.'
            $state.go('event', { id: event_id })
          , (headers) ->
            callback?(false)
            flash.error = headers.message

    # Sets user.isRegistered
    userRegistered: (user, eventId) ->
      user.isRegistered = false

      if user.hasOwnProperty '$promise'
        user.$promise.then ->
          VolunteerEvent.query { volunteer: user._id, event: eventId }, (volunteerEvents) ->
            user.isRegistered = (volunteerEvents.length > 0)
          , (headers) ->
            flash.error = headers.message

    # event must have event.$promise
    getUsersForEvent: (eventId) ->
      volunteers = [] # return value
      def = $q.defer()

      VolunteerEvent.query { event: eventId }, (volunteerEvents) ->
        volunteers.push volevnt.volunteer for volevnt in volunteerEvents
      , (headers) ->
        flash.error = headers.message
      volunteers

    # Returns hash of events that user is registered for.
    # Will be completed by return_val.promise
    getEventsForUser: (userId) ->
      registeredEvents = {}
        
      if Auth.isLoggedIn()
        VolunteerEvent.query { volunteer: userId }, (volunteerEvents) ->
          registeredEvents[ve.event._id] = ve.event for ve in volunteerEvents
        , (headers) ->
          flash.error = headers.message
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

      now = new Date()
      event.$promise ||= $q.when(event)
      event.$promise.then (event) ->
        event.start ||= now
        event.end ||= now
        start = new Date(event.start)
        end = new Date(event.end)
        event.date = start.toDateString()
        event.starts = start.toLocaleTimeString({hour: 'numeric', minute: 'numeric'})
        event.ends = end.toLocaleTimeString({hour: 'numeric', minute: 'numeric'})
        event.hours = event.starts + ' to ' + event.ends
        event.isoDate = new Date(event.start).toISOString().substr(0, 10)
        event.dateAndTime = event.date + ', ' + event.hours
        event.registered = [event.n_volunteers || 0, event.volunteerSlots].join('/')
        event.ended = (new Date(event.end) < now)
      event

    visitEvent: (event_id) ->
      $state.go('event', { id: event_id })

    sortByDate: (_a, _b) ->
      a = new Date(_a.substr(0, _a.indexOf(',')))
      b = new Date(_b.substr(0, _b.indexOf(',')))
      
      if a < b then return -1
      if a > b then return 1
      return 0

    deleteEvent: (event, cb) ->
      del = ->
        event.$remove ->
          flash.success = 'Removed event.'
          cb? true
        , (headers) ->
          flash.error = headers.message
          cb? false

      Modal.confirm.delete(del) event.name
