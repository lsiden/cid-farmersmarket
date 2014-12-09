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
        {
          field: 'dateAndTime'
          displayName: 'Date'
          sortable: true
          sortFn: eventService.sortByDate
          minWidth: 275
          cellClass: 'date-and-time'
        }
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
        {
          field: 'attended'
          displayName: 'Attended'
          cellTemplate: 'app/admin/account/index/attended.cell.template.html'
          sortable: true
          width: 100
          maxWidth: 100
        }
      ]
