module.exports =
  
  # GET a list of repositories for the authenticated user
  getAllRepositoriesForAuthedUser: (options = {}, callback) ->
    @_request "GET", "1.0/user/repositories", options.params, options.payload, callback
  