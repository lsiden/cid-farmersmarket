angular.module 'farmersmarketApp'
.factory 'eventService', (Auth, $cookieStore, $state, VolunteerEvent, flash) ->
  
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

    visitEvent: (event_id) ->
      $state.go('event', { id: event_id })

  return self
