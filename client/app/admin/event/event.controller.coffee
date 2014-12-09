'use strict'

# Controller for viewing

angular.module 'farmersmarketApp'
.controller 'AdminEventCtrl', ($scope, $state, flash, Event, VolunteerEvent, User, eventService) ->

  $scope.edit = ->
    $state.go('admin-event-edit', { id: $state.params.id })

  recordAttendance = (userId, eventId, attended) ->
    VolunteerEvent.query { volunteer: userId, event: eventId }, (ar_ve) ->
      # Expecing array of only one element
      for ve in ar_ve
        ve.attended = attended
        ve.$update ->
          flash.success = 'Recorded attendance.'
        , (headers) ->
          flash.error = headers.message
    , (headers) ->
      flash.error = headers.message

  # console.log $state.params
  $scope.volunteers = []
  $scope.event = Event.get { id: $state.params.id }, (event) ->
    eventService.decorate event
  , (headers) ->
    flash.error = headers.message
 
  VolunteerEvent.query { event: $state.params.id }, (ar_ve) ->
    if ar_ve.length > 0
      $scope.volunteers = User.query { '_id[]': ( ve.volunteer._id for ve in ar_ve )}, (volunteers) ->
        ve_for_volunteer = {}
        ve_for_volunteer[ve.volunteer._id] = ve for ve in ar_ve
        v.attended = ve_for_volunteer[v._id].attended for v in volunteers

        for i in [0 .. volunteers.length-1]
          do (i) ->
            $scope.$watch 'volunteers[:i].attended'.replace(/:i/, i), (attended, oldVal) ->
              if attended != oldVal
                recordAttendance volunteers[i]._id, $scope.event._id, attended
      , (headers) ->
        flash.error = headers.message

  $scope.volunteerGridOptions = 
    data: 'volunteers'
    enableRowSelection: false
    enableCellSelection: false
    sortInfo: { fields: ['name'], directions: ['asc'] }
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/account/index/name.cell.template.html'
        sortable: true
      }
      {
        field: 'email'
        displayName: 'Email'
        cellTemplate: 'app/admin/account/index/email.cell.template.html'
        sortable: false
      }
      { field: 'phone', displayName: 'Phone', sortable: false }
      {
        field: 'attended'
        displayName: 'Attended'
        sortable: true
        cellTemplate: 'app/admin/event/cell-attended.html'
      }
    ]
