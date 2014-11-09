angular.module 'farmersmarketApp'
.directive 'mailTo', ->
  restrict: 'E'
  scope:
    to: '@'
  template: '<a href="mailto:{{to}}">{{to}}</a>'
