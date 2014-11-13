'use strict'

# Controller for /events listing

angular.module 'farmersmarketApp'
.controller 'AdminEventsCtrl', ($scope, flash, Event, eventService) ->

  sortByDate = (_a, _b) ->
    a = new Date(_a)
    b = new Date(_b)
    
    if a < b then return -1
    if a > b then return 1
    return 0

  $scope.errors = {}
  $scope.events = []
  $scope.eventGridOptions = 
    data: 'events'
    enableRowSelection: false
    enableCellSelection: false
    sortInfo: { fields: ['date'], directions: ['asc'] }
    columnDefs: [
      {
        field: 'name'
        displayName: 'Name'
        cellTemplate: 'app/admin/events/name.cell.template.html'
        sortable: true
      }
      # { field: 'organization', displayName: 'Organization', sortable: true }
      {
        field: 'organization'
        displayName: 'Organization'
        cellTemplate: 'app/admin/events/organization_name.cell.template.html'
        sortable: true
      }
      { field: 'date', displayName: 'Date', sortable: true, sortFn: sortByDate }
      { field: 'hours', displayName: 'Hours', sortable: false }
      { field: 'attendance', displayName: 'Volunteers/Slots', sortable: false }
      { field: 'active', displayName: 'Active', sortable: false }
    ]

  eventQuery = { end: '>' + (new Date()).addDays(-1) }
  # Request all events that haven't ended
  # console.log(eventQuery);

  Event.query eventQuery, (events) ->
    $scope.events = (eventService.decorate event for event in events)
  , (headers) ->
    flash.error = headers.message
