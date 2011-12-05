var connectTimeout  = require('connect-timeout'),
    form            = require('connect-form'),
    resource        = require('express-resource'),
    mongoose        = require('mongoose'),
    stylus          = require('stylus'),
    util            = require('util'),
    passport        = require('passport'),
    connectRedis    = require('connect-redis')(require('connect'))
    redis           = require('redis');

require('../../lib/mathlib.uuid');

// Middleware

exports = module.exports = function(express) {
  
  //server.use(express.logger({ format: ':method :url' }));
  server.use(connectTimeout({ time: options.reqTimeout }));
  server.use(stylus.middleware({
    src: server.set('views'),
    dest: server.set('public'),
    debug: false,
    compileMethod: function(str) {
      return stylus(str, path)
        .set('compress', options.compressCss)
        .set('filename', path);
    },
    force: true
  }));
  server.use(express['static'](server.set('public')));
  server.use(express.cookieParser());
  server.use(express.session({
    secret: Math.uuidFast(),
    key: options.sessionKey,
    store: new connectRedis({
      maxAge: options.maxAge,
      host: options.redis.host,
      port: options.redis.port
    })
  }));
  server.use(form({ keepExtensions: true }));
  server.use(express.bodyParser());
  server.use(passport.initialize());
  server.use(passport.session());
  server.use(server.router);
  server.use(express.errorHandler({ dumpExceptions: options.dumpExceptions, showStack: options.showStack}));
};