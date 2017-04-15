# https://confluence.atlassian.com/bitbucket/repository-resource-423626331.html

async = require 'async'

module.exports =
  
  # GET a list of repositories for an account
  ## Gets the list of repositories owned by the specified account. If the caller is properly authenticated and
  ## authorized, this method returns a collection containing public and private repositories. Otherwise, this
  ## method returns a collection of the public repositories. This produces a paginated response.
  
  getRepositories: (options = {}, callback) ->
    @_request "GET", "2.0/repositories/#{options.team or options.owner}", options.params, options.payload, callback
  
  getAllRepositories: (options = {}, callback) ->
    bitbucket = @; pagelen = 0; size = 1; page = 1;repositories = [] 
    options.params or= {}   
    options.params.pagelen or= '100'
    async.whilst(
      ->
        pagelen < size
      (cb)->
        options.params.page = page
        bitbucket.getRepositories options, (err, res) ->
          pagelen += res.pagelen
          page++
          size = res.size
          repositories = repositories.concat res.values
          cb err
      (err)->
        callback err, repositories
    )
  
  # https://api.bitbucket.org/2.0/repositories/{owner}/{repo_slug}
  createRepository: (options = {}, callback) ->
    #@_assertOption options, 'repo_slug owner'
    options.payload or= {}
    options.payload.scm or= 'git'
    options.payload.name or= options.repo_slug
    options.payload.is_private or= true
    options.payload.fork_policy or= 'no_forks'
    options.payload.has_issues or= true
    
    @_request "POST", "2.0/repositories/#{options.team or options.owner}/#{options.repo_slug}", options.params, options.payload, callback
  
  # DELETE https://api.bitbucket.org/2.0/repositories/{owner}/{repo_slug} 
  deleteRepository: (options = {}, callback) ->
    @_request "DELETE", "2.0/repositories/#{options.team or options.owner}/#{options.repo_slug}", options.params, options.payload, callback

  
  # GET https://api.bitbucket.org/2.0/repositories/{owner}/{repo_slug}
  getRepository: (options = {}, callback) ->
    @_request "GET", "2.0/repositories/#{options.team or options.owner}/#{options.repo_slug}", options.params, options.payload, callback
  
  # GET https://api.bitbucket.org/2.0/repositories/{owner}/{repo_slug}/forks
  getRepositoryForks: (options = {}, callback) ->
    @_request "GET", "2.0/repositories/#{options.team or options.owner}/#{options.repo_slug}/forks", options.params, options.payload, callback

