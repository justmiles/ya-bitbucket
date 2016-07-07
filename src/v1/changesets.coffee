# https://confluence.atlassian.com/bitbucket/changesets-resource-296095208.html#changesetsResource-POSTanewcommentonachangeset


module.exports =
  
  createChangesetComment: (options = {}, callback) ->
    @_request "POST", "1.0/repositories/#{options.team or options.owner or @owner}/#{options.repo_slug}/changesets/#{options.node}/comments", options.params, options.payload, callback
    
