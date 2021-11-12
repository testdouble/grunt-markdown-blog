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
    "#{@url}/#{post.htmlPath()}"

  getPosts: ->
    @posts.posts

    # previously, site.posts was an instance of the Posts class
    # which depended on some coffeescript 1.x + es5 prototype
    # cleverness to inherit properties from the native Array class

    # class Posts
    #  @:: = new Array
    #  constructor: () ->
    #    posts.__proto__ = Posts::

    # we can't really do this in es6 classes so I created
    # this accessor so that upstream users don't need to
    # double reference site.posts.posts in their pug templates

    # the only place this behaviour was used in upstream packages
    # was in blogs that had used lineman-blog-template to scaffold
    # their repos
    # - https://github.com/linemanjs/lineman-blog-template/blob/f3c996fc8b8ff1d22b2dca2825e040741528ad4d/app/templates/archive.us#L5
    # - https://github.com/linemanjs/lineman-blog-template/blob/f3c996fc8b8ff1d22b2dca2825e040741528ad4d/app/templates/index.us#L1

    # the only other place within this codebase that depended
    # on this behaviour was lib/generates_rss.coffee
    # - https://github.com/testdouble/grunt-markdown-blog/blob/cdee500123face4bb9c897a51af682c9e5df5118/lib/generates_rss.coffee#L21