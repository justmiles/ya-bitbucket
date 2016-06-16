# Examples

```
bitbucket = new Bitbucket(
  username: 'username'
  password: 'password'
)

bitbucket.getRepositories { team: 'team' }, (err, res) ->
  bitbucket.log err, res

bitbucket.createRepository { 
  team: 'team' 
  repo_slug: 'test' 
  }, (err, res) ->
  bitbucket.log err, res
  bitbucket.log err, res

bitbucket.deleteRepository { 
  team: 'team' 
  repo_slug: 'test' 
  }, (err, res) ->
  bitbucket.log res

bitbucket.getRepository { 
  team: 'team' 
  repo_slug: 'test' 
  }, (err, res) ->
  bitbucket.log res
```