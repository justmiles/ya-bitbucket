# https://confluence.atlassian.com/bitbucket/pullrequests-resource-423626332.html#pullrequestsResource-GETalistofopenpullrequests


module.exports =
  
  createPullRequestComment: (options, callback) ->
    @_request "POST", "1.0/repositories/#{options.team or options.owner or @owner}/#{options.repo_slug}/pullrequests/#{options.pull_request_id}/comments", options.params, options.payload, callback
