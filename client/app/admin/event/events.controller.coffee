'use strict'

# Controller for /events listing

angular.module 'farmersmarketApp'
.controller 'AdminEventsCtrl', ($scope, flash, Event, eventService) ->

  $scope.errors = {}

  eventQuery = { end: '>' + (new Date()).addDays(-1) }
  # Request all events that haven't ended
  # console.log(eventQuery);

  $scope.events = Event.query eventQuery, (events) ->
      eventService.decorate event for event in events
  , (headers) ->
    flash.error = headers.message

  $scope.eventGridOptions = 
    data: 'events'
    enableRowSelection: false
    enableCellSelection: false
    sortInfo: { fields: ['date'], directions: ['asc'] }
    columnDefs: [
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
      { field: 'date', displayName: 'Date', sortable: true, sortFn: eventService.sortByDate }
      { field: 'hours', displayName: 'Hours', sortable: false }
      { field: 'attendance', displayName: 'Volunteers/Slots', sortable: false }
      { field: 'active', displayName: 'Active', sortable: false }
    ]
