Rss = null
GeneratesRss = null

Given -> Rss = td.constructor(["item", "xml"])
Given -> td.when(Rss::xml()).thenReturn(@feedXml = "feedXml")
Given -> GeneratesRss = require "../lib/generates_rss"

describe "GeneratesRss", ->
  Given -> @site =
    title: "title"
    description: "description"
    url: "url"
    paths:
      rss: "path/feed.xml"
    author: "author"
    posts: []
    getPosts: -> []
    urlFor: (post) -> "url/#{post.title()}"

  When -> @subject = new GeneratesRss(@site, Rss)
  When -> @feed = @subject.generate()
  Then -> td.verify Rss
    title: "title"
    description: "description"
    feed_url: "url/path/feed.xml"
    site_url: "url"
    author: "author"
  Then -> @feed == @feedXml

  context "with posts", ->
    Given -> @site.getPosts = -> [
      {
        title: -> "post1 title"
        content: -> "post1 content"
        time: -> "post1 time"
      },
      {
        title: -> "post2 title"
        content: -> "post2 content"
        time: -> "post2 time"
      }
    ]

    context "rssCount less than number of posts", ->
      Given -> @site.rssCount = 1
      Then -> td.verify Rss::item { title: "post2 title", description: "post2 content", url: "url/post2 title", date: "post2 time" }

    context "rssCount equal to number of posts", ->
      Given -> @site.rssCount = 2
      Then -> td.verify Rss::item { title: "post1 title", description: "post1 content", url: "url/post1 title", date: "post1 time" }
      Then -> td.verify Rss::item { title: "post2 title", description: "post2 content", url: "url/post2 title", date: "post2 time" }

    context "rssCount greater than number of posts", ->
      Given -> @site.rssCount = 3
      Then -> td.verify Rss::item { title: "post1 title", description: "post1 content", url: "url/post1 title", date: "post1 time" }
      Then -> td.verify Rss::item { title: "post2 title", description: "post2 content", url: "url/post2 title", date: "post2 time" }
