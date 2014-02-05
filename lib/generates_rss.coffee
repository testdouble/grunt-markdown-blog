module.exports = class GeneratesRss
  constructor: (@site) ->
    @Rss = require('rss')

  generate: ->
    feed = @createFeed()
    @addPostsTo(feed)
    feed.xml()

  createFeed: ->
    new @Rss
      title: @site.title
      description: @site.description
      feed_url: "#{@site.url}/#{@site.paths.rss}"
      site_url: @site.url
      author: @site.author

  addPostsTo: (feed) ->
    if @site.rssCount > 0
      @site.posts.slice(-@site.rssCount).reverse().forEach (post) =>
        feed.item
          title: post.title()
          description: post.content()
          url: @site.urlFor(post)
          date: post.time()
