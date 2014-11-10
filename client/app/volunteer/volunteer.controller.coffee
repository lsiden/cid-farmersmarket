'use strict'

sortByDate = (_a, _b) ->
  a = new Date(_a)
  b = new Date(_b)
  
  if a < b then return -1
  if a > b then return 1
  return 0

makeGridOptions = (gridItemsName, sortDir) ->
  data: gridItemsName
  enableRowSelection: false
  enableCellSelection: false
  sortInfo: { fields: ['date'], directions: [sortDir] }
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
    { 
      field: 'dateAndTime'
      displayName: 'Time'
      sortable: true
      sortFn: sortByDate
    }
    {
      field: 'contactInfo'
      displayName: 'Contact'
      sortable: true
    }
  ]

makeGridItem = (event) ->
  start = new Date(event.start)
  end = new Date(event.end)
  org = event.organization

  href: '/admin/events/' + event._id
  name: event.name
  organization: event.organization
  href_organization: '/admin/organizations/' + event.organization._id
  dateAndTime: start.toDateString() + ', ' + start.shortTime() + ' - ' + end.shortTime()
  contactInfo: org.contact + ', ' + org.phone + ', ' + org.email

angular.module 'farmersmarketApp'
.controller 'VolunteerCtrl', ($scope, $state, flash, Volunteer, Event) ->
  $scope.volunteer = {}
  $scope.masterVolunteer = {}
  $scope.pastGridItems = []
  $scope.futureGridItems = []
  $scope.message = ''

  $scope.pastGridOptions = makeGridOptions 'pastGridItems', 'desc'
  $scope.futureGridOptions = makeGridOptions 'futureGridItems', 'asc'

  populateGridItems = (volunteer_id) ->
    futureEventsQuery = { volunteer_id: volunteer_id, end: '>' + (new Date()).addDays(-1) }
    pastEventsQuery = { volunteer_id: volunteer_id, end: '<' + new Date() }

    Event.query pastEventsQuery, (events) ->
      $scope.pastGridItems = (makeGridItem event for event in events)
    , (headers) ->
      flash.error = headers.message

    Event.query futureEventsQuery, (events) ->
      $scope.futureGridItems = (makeGridItem event for event in events)
    , (headers) ->
      flash.error = headers.message

  id = $state.params.id
  
  if id && id != 'new'
    Volunteer.get { id: $state.params.id }, (volunteer) ->
      _volunteer = volunteer
      $scope.volunteer.id = volunteer._id
      $scope.volunteer.name = volunteer.name
      $scope.volunteer.phone = volunteer.phone
      $scope.volunteer.email = volunteer.email
      $scope.masterVolunteer = angular.copy($scope.volunteer)
      populateGridItems volunteer._id
    , (headers) ->
      flash.error = headers.data.message
  else
    _volunteer = new Volunteer() # from server
    $scope.volunteer.email = $state.params.email

  $scope.isFormChanged = (volunteer) ->
    !angular.equals(volunteer, $scope.masterVolunteer)

  $scope.resetForm = ->
    $scope.volunteer = angular.copy($scope.masterVolunteer)
  
  $scope.saveVolunteer = (form) ->
    # $scope.submitted = true

    if !form.$valid
      return
    _volunteer.name = $scope.volunteer.name
    _volunteer.phone = $scope.volunteer.phone
    _volunteer.email = $scope.volunteer.email

    if id && id != 'new'
      _volunteer.$update (data, headers) ->
        # $scope.message = 'Content info successfully changed.'
        flash.success = 'Thank you for updating your contact info.'
        $state.go('main')
      , (headers) ->
        # $scope.message = 'Cannot update your contact info now.'
        flash.error = headers.message
    else
      _volunteer.$save (data, headers) ->
        # $scope.message = 'Content info successfully changed.'
        flash.success = 'Congratulations!  You are now registered.'
        $state.go('main')
      , (headers) ->
        # $scope.message = 'Cannot update your contact info now.'
        flash.error = headers.message

angular.module 'farmersmarketApp'
.directive 'editVolunteerInfo', ->
  restrict: 'E'
  scope: true # inherit parent scope
  templateUrl: 'app/volunteer/volunteer-info-form.html'
