'use strict'

angular.module 'farmersmarketApp'
.factory 'adminService', (eventService) ->

  self =

    # dateDir: 'asc' or 'desc'
    eventGridOptions: (dataName, dateDir) ->
      data: dataName
      enableRowSelection: false
      enableCellSelection: false
      sortInfo: { fields: ['date'], directions: [dateDir] }
      columnDefs: [
        { field: 'date', displayName: 'Date', sortable: true, sortFn: eventService.sortByDate }
        { field: 'hours', displayName: 'Hours', sortable: false }
        {
          field: 'name'
          displayName: 'Name'
          cellTemplate: 'app/admin/event/index/name.cell.template.html'
          sortable: true
        }
        {
          field: 'organization'
          displayName: 'Organization'
          cellTemplate: 'app/admin/event/index/organization_name.cell.template.html'
          sortable: true
        }
        { field: 'attended', displayName: 'Attended', sortable: true }
      ]
