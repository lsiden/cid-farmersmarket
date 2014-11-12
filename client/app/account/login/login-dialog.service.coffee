angular.module 'farmersmarketApp'
.factory 'loginDlg', (flash, User, $modal) ->
  ->
    $modal.open
      # templateUrl: 'app/account/login/login-dlg.html'
      template: 'here is the <form />'
      controller: 'LoginCtrl'
    .result.then (user) ->
      if user
        flash.success = 'Thank you for loggin on!'
    , (headers) ->
      flash.error = headers.message
