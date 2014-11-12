'use strict'

describe 'loginDlg service', ->

  beforeEach module 'farmersmarketApp'

  loginDlg = undefined

  beforeEach inject (_loginDlg_) ->
    loginDlg = _loginDlg_

  it 'should be found', ->
    expect(!!loginDlg).toBe true
