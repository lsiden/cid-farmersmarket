angular.module 'farmersmarketApp'
.factory 'eventService', (Auth, $cookieStore, $state, $q, VolunteerEvent, flash) ->
  
  self =
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
        href_organization: '/admin/organizations/' + event.organization._id
        attendance: '' + event.volunteers + '/' + event.volunteerSlots
      event

    visitEvent: (event_id) ->
      $state.go('event', { id: event_id })

  return self
