describe 'LoginForm directive', ->
  scope = null
  elem = null
  directive = null
  compiled = null
  html = null
      
  beforeEach ->
    module('farmersmarketApp');

    # http://abou-kone.com/2013/06/24/angularjs-unit-testing-that-involves-html-templates/
    module('app/account/login/login-form.html')
    
  beforeEach ->
    html = '<div><login-form /></div>'
    
    inject ($compile, $rootScope, $httpBackend) ->
      # $httpBackend.whenGET('/api/events').respond {}
      scope = $rootScope.$new()
      elem = angular.element(html)
      compiled = $compile(elem)
      compiled(scope)
      scope.$digest()

  it 'Should expand to a form element', ->
    #test to see if it was updated.
    # console.log(elem.html())
    expect(angular.element(elem).find('form').length).toBe 1
