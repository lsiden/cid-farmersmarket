'use strict'

# Controller for /events listing

angular.module 'farmersmarketApp'
.controller 'AdminEventsCtrl', ($scope, $state, flash, Event, eventService) ->

  $scope.errors = {}
  today = new Date()
  fromDate = new Date(today.getTime() - 30 * 24 * 3600 * 1000)
  thruDate = new Date(today.getTime() + 60 * 24 * 3600 * 1000)
  $scope.isoFromDate = fromDate.toISOString().substr(0, 10)
  $scope.isoThruDate = thruDate.toISOString().substr(0, 10)

  $scope.new = ->
    Event.save (event) ->
      $state.go('admin-event-edit', { id: event._id })

  $scope.deleteEvent = eventService.deleteEvent

  fetchEvents = ->
    eventQuery =
      from: $scope.isoFromDate
      thru: $scope.isoThruDate
    # console.log(eventQuery);

    $scope.events = Event.query eventQuery, (events) ->
      eventService.decorate event for event in events
    , (headers) ->
      flash.error = headers.message

  fetchEvents()

  $scope.$watch 'isoFromDate', (fromDate, oldDate) ->
    fetchEvents() if fromDate != oldDate

  $scope.$watch 'isoThruDate', (thruDate, oldDate) ->
    fetchEvents() if thruDate != oldDate

  $scope.eventGridOptions = 
    data: 'events'
    enableRowSelection: false
    enableCellSelection: false
    sortInfo: { fields: ['date'], directions: ['asc'] }
    columnDefs: [
      { field: 'dateAndTime', displayName: 'Date and Time', sortable: true, sortFn: eventService.sortByDate, width: '325' }
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/event/index/name.cell.template.html'
        sortable: true
      }
      # { field: 'organization', displayName: 'Organization', sortable: true }
      {
        field: 'organization'
        displayName: 'Organization'
        cellTemplate: 'app/admin/event/index/organization_name.cell.template.html'
        sortable: true
      }
      { field: 'registered', displayName: 'Slots', sortable: false, width: 75 }
      { 
        field: 'actions'
        displayName: 'Actions'
        cellTemplate: 'app/admin/event/index/actions.cell.template.html'
        sortable: false
        width: 75
      }
    ]

  $scope.deleteEvent = (event) ->
    eventService.deleteEvent event, (deleted) ->
      if (deleted)
        _.remove $scope.events, event
