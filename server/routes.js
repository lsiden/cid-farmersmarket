/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/resetpw', require('./api/resetpw'));
  app.use('/api/organizations', require('./api/organization'));
  app.use('/api/volunteer_events', require('./api/volunteer_event'));
  app.use('/api/events', require('./api/event'));
  app.use('/api/users', require('./api/user'));

  app.use('/auth', require('./auth'));

  app.route('/resetpw/:key').get(function(req, res, next) {
    var tracer = require('tracer').console({ level: 'debug' });
    var rpw = require('./api/resetpw/resetpw.controller');
    tracer.debug(rpw);
    rpw.resetpw(req, res);
  });
  
  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendfile(app.get('appPath') + '/index.html');
    });
};
