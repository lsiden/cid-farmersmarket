angular.module 'farmersmarketApp'
  .controller 'inputEmailDlgCtrl', ($scope, $modalInstance) ->

    $scope.email = ''

    $scope.cancel = ->
      $modalInstance.dismiss('cancelled')
    
    $scope.save = ->
      $modalInstance.close $scope.email
