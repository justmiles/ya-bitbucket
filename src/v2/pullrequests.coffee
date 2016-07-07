# https://confluence.atlassian.com/bitbucket/pullrequests-resource-423626332.html#pullrequestsResource-GETalistofopenpullrequests


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
    