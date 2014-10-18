_ = require('underscore')

module.exports = class Site
  constructor: (config, @posts, @pages) ->
    _(@).extend(config)

  olderPost: (post) ->
    @posts.older post # should be deprecated in favor of posts.older directly

  newerPost: (post) ->
    @posts.newer post # should be deprecated in favor of posts.newer directly

  htmlFor: (post) -> # should be deprecated in favor of posts.htmlFor directly
    @posts.htmlFor this, post

  urlFor: (post) ->
    "#{@url}/#{post.path}"
