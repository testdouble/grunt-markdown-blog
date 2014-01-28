_ = require('underscore')

module.exports = class Site
  constructor: (config, posts, @postLayout) ->
    _(@).extend(config)
    @posts = _(posts).sortBy((p) -> p.time())

  addPages: (@pages, @pageLayout) ->

  olderPost: (post) ->
    return if _(@posts).first() == post
    @posts[_(@posts).indexOf(post) - 1]

  newerPost: (post) ->
    return if _(@posts).last() == post
    @posts[_(@posts).indexOf(post) + 1]

  htmlFor: (post) ->
    @postLayout.htmlFor(post: post, site: this)

  urlFor: (post) ->
    "#{@url}/#{post.htmlPath()}"
