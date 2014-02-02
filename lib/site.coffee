_ = require('underscore')

module.exports = class Site
  constructor: (config, @posts) ->
    _(@).extend(config)

  addPages: (@pages, @pageLayout) ->

  olderPost: (post) ->
    return if _(@posts).first() == post
    @posts[_(@posts).indexOf(post) - 1]

  newerPost: (post) ->
    return if _(@posts).last() == post
    @posts[_(@posts).indexOf(post) + 1]

  htmlFor: (post) -> # should be deprecated in favor of posts.htmlFor directly
    @posts.htmlFor this, post

  urlFor: (post) ->
    "#{@url}/#{post.htmlPath()}"
