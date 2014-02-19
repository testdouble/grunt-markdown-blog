module.exports = class GeneratesRss
  constructor: (@site) ->
    @Rss = require('rss')

  generate: ->
    feed = @createFeed()
    @addPostsTo(feed)
    feed.xml()

  createFeed: ->
    new @Rss @_feedInfo()

  addPostsTo: (feed) ->
    if @site.rssCount > 0
      @site.posts.slice(-@site.rssCount).reverse().forEach (post) =>
        feed.item @_itemInfo(post)

  _feedInfo: ->
    @site.rss.feedInfo @site,
      title: @site.title
      description: @site.description
      feed_url: "#{@site.url}/#{@site.paths.rss}"
      site_url: @site.url
      author: @site.author

  _itemInfo: (post) ->
    @site.rss.itemInfo @site, post,
      title: post.title()
      description: post.content()
      url: @site.urlFor(post)
      date: post.time()
