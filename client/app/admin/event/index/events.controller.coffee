'use strict'

# Controller for /events listing

angular.module 'farmersmarketApp'
.controller 'AdminEventsCtrl', ($scope, flash, Event, eventService) ->

  $scope.errors = {}
  fromDate = new Date()
  thruDate = new Date()
  fromDate.addDays(-30)
  thruDate.addDays(60)
  $scope.isoFromDate = fromDate.toISOString().substr(0, 10)
  $scope.isoThruDate = thruDate.toISOString().substr(0, 10)

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
      { field: 'date', displayName: 'Date', sortable: true, sortFn: eventService.sortByDate }
      { field: 'hours', displayName: 'Hours', sortable: false }
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
      { field: 'attendance', displayName: 'Volunteers/Slots', sortable: false }
      { field: 'active', displayName: 'Active', sortable: false }
    ]
