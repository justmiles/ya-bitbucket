# https://confluence.atlassian.com/bitbucket/pullrequests-resource-423626332.html#pullrequestsResource-GETalistofopenpullrequests

async = require 'async'

module.exports =
  
  getPullRequests: (options = {}, callback) ->
    @_request "GET", "2.0/repositories/#{options.team or options.owner or @owner}/#{options.repo_slug}/pullrequests", options.params, options.payload, callback
    
  getOpenPullRequests: (options = {}, callback) ->
    options.state = 'OPEN'
    @getPullRequests options, callback
    
  getClosedPullRequests: (options = {}, callback) ->
    options.state = 'CLOSED'
    @getPullRequests options, callback
    
  getMergedPullRequests: (options = {}, callback) ->
    options.state = 'MERGED'
    @getPullRequests options, callback
    
  
  # @example Get all open pull requests
  # bitbucket.getAllPullRequests {
  #   team: 'someteam'
  # }, (err, res) ->
  #   console.log err, res
  #  
  # @option option [String] team 
  # @option option [String] user
  getAllPullRequests: (options = {}, callback) ->
    bitbucket = @
    @getAllRepositoriesForAuthedUser options, (err, res) ->
      return err if err
      pullRequests = []
      async.each res, (repo, done) ->
        options.repo_slug = repo.slug
        bitbucket.getPullRequests options, (err, res) ->
          pullRequests = pullRequests.concat res.values
          done err
      , (err) ->
        callback err, pullRequests
      
        