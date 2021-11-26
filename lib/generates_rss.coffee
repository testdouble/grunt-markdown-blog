module.exports = class GeneratesRss
  constructor: (@site, @FeedGenerator = require('feed').Feed) ->

  generate: ->
    feed = @createFeed()
    @addPostsTo(feed)
    return
      rss: feed.rss2()
      json: feed.json1()

  createFeed: ->
    new @FeedGenerator
      title: @site.title
      link: @site.url
      description: @site.description
      language: "#{@site.language}"
      image: "#{@site.image}"
      favicon: "#{@site.favicon}"
      copyright: "Copyright © #{new Date().getFullYear()}, #{@site.author}"
      feedLinks:
        rss: "#{@site.url}/#{@site.paths.rss}"
        json: "#{@site.url}/#{@site.paths.json}"
      author:
        name: @site.author
        link: @site.authorUrl

  addPostsTo: (feed) ->
    if @site.rssCount > 0
      @site.getPosts().slice(-@site.rssCount).reverse().forEach (post) =>
        feed.addItem
          title: post.title()
          id: @site.urlFor(post)
          url: @site.urlFor(post)
          description: post.description()
          content: post.content()
          date: new Date(post.time())
