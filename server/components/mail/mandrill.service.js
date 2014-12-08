'use strict';

exports.fromEmail = function() { return 'admin@experiencejackson.com'; };
exports.fromName = function() { return 'Admin'; };

var _ = require('lodash');
var mandrill_api = require('mandrill-api/mandrill')
var mandrill = new mandrill_api.Mandrill(process.env.MANDRILL_API_KEY);
var tracer = require('tracer').console({ level: 'info' });

exports.send = function(to, cc, subj, html, done) {
  tracer.info('sending mail');
  tracer.info(to);
  tracer.info(subj);
  var params = {
    message: {
      to: to,
      cc: cc,
      subject: subj,
      html: html,
      from_email: exports.fromEmail(),
      from_name: exports.fromName()
    }
  };
  mandrill.messages.send(params, function(res) {
    tracer.log(res);
    if ({ rejected: true, invalid: true}[res.status]) { return done(res); }
    if (done) { done(null, res); }
  });
};
