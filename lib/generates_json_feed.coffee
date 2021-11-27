module.exports = class GeneratesJsonFeed
  constructor: (@site) ->

  generate: ->
    feed = @createFeed()
    @addPostsTo(feed)
    JSON.stringify(feed, null, 2)

  createFeed: ->
    return {
      version: "https://jsonfeed.org/version/1.1"
      title: @site.title
      description: @site.description
      home_page_url: @site.url
      feed_url: "#{@site.url}/#{@site.paths.json}"
      authors: [
        {
          name: @site.author
          url: @site.authorUrl
        }
      ]
      items: []
    }

  addPostsTo: (feed) ->
    if @site.feedCount > 0
      @site.getPosts().slice(-@site.feedCount).reverse().forEach (post) =>
        feed.items.push
          id: @site.urlFor(post)
          url: @site.urlFor(post)
          title: post.title()
          summary: post.description()
          date_published: post.rfc3339_time()
          authors: [{
            name: @site.author
          }]
          content_html: post.content()
