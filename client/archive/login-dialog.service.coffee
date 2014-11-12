angular.module 'farmersmarketApp'
.factory 'loginDlg', (flash, User, $modal) ->
  open: ->
    $modal.open
      # template: 'here is the <form />'
      templateUrl: 'app/account/login/login-dlg.html'
      controller: 'LoginCtrl'
    .result.then (user) ->
      if user
        flash.success = 'Thank you for loggin on!'
    , (headers) ->
      flash.error = headers.message
