'use strict';

var _ = require('lodash')
var tracer = require('tracer').console({ level: 'info' });
var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

function processQuery(_query) {
  var query = _.cloneDeep(_query);
  tracer.debug(query);
  for (var key in query) {
    if (_.isArray(query[key])) {
      query[key] = (key === '_id[]') ? { $in: query[key].map(toObjectId) } : { $in: query[key] };
    }
  }
  tracer.debug(query);
  return query;
}

function handleError(res, err) {
  // tracer.error(err);
  console.log(err);
  return res.send(500, err);
}

function toObjectId(id) { 
  return new Schema.Types.ObjectId(id)
}

exports.withAuthUser = function(user, done) {
  var app = require('../app');
  var request = require('supertest');
  var tracer = require('tracer').console({ level: 'warn' });

  tracer.trace('withAuthUser');
  tracer.trace(user.email);

  // Authenticate user
  request(app).post('/auth/local')
  .send({email: user.email, password: user.password})
  .expect(200)
  .expect('Content-Type', /json/)
  .end(function(err, res) {
    // var tracer = require('tracer').console({ level: 'debug' });
    // tracer.debug(res.body);
    done(err, res.body.token, res);
  });
};

exports.processQuery = processQuery;
exports.handleError = handleError;
exports.toObjectId = toObjectId;
