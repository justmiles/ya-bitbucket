request = require 'request'
logger  = require 'debug-logger'
async   = require 'async'
fs      = require 'fs'
path    = require 'path'

class Bitbucket
  constructor: (options = {}) ->
    @log = logger('Bitbucket')
    
    @host         = options.host          or 'api.bitbucket.org'
    @username     = options.username      or process.env.BITBUCKET_USERNAME
    @password     = options.password      or process.env.BITBUCKET_PASSWORD
    @concurrency  = options.concurrency   or 1
    
    
    for file in fs.readdirSync path.join __dirname, 'v2'
      endpoint = file.replace /.coffee|.js/, ''
      methods = require path.join __dirname, 'v2', file
      for method, fn of methods
        Bitbucket::[method] = fn
    
    for file in fs.readdirSync path.join __dirname, 'v1'
      endpoint = file.replace /.coffee|.js/, ''
      methods = require path.join __dirname, 'v1', file
      for method, fn of methods
        Bitbucket::[method] = fn
    
  _request:(method, api, params, payload, callback) ->
    task =
      method: method
      api: api
      params: params
      payload: payload
      apiVersion: @apiVersion
      apiKey: @apiKey
      delay: @delay
      bitbucket: @
      
    @_queue.push task, callback, (x) ->
      console.log x
      
        
  _queue: async.queue ((task, callback) ->
    
    options =
      url: "https://#{task.bitbucket.host}/#{task.api}"
      method: task.method
      headers:
        authorization: "Basic " + new Buffer( "#{task.bitbucket.username}:#{task.bitbucket.password}" ).toString("base64")
      json: true
      
    options.qs = task.params if task.params
    options.body = task.payload if task.payload

    task.bitbucket.log 'Request options', options
    task.bitbucket.log 'Request payload', task.payload if task.payload

    setTimeout (->
      request options, (err, res, body) ->
        GLOBAL.calls or= 0
        calls += 1
        
        return callback new Error(err) if err
        
        return callback new Error('No response received') unless res
        
        if body?.error?
          task.bitbucket.log.error body.error?.message
          return callback new Error(body.error?.message)
          
        else
          return callback null, body

    ), task.delay

  ), @concurrency
  
    
  _assertOption: (options, needs) ->
    

module.exports = Bitbucket
