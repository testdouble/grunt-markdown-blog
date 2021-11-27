GeneratesJsonFeed = null

Given -> GeneratesJsonFeed = require "../lib/generates_json_feed"

describe "GeneratesJsonFeed", ->
  Given -> @site =
    title: "title"
    description: "description"
    url: "url"
    paths:
      json: "path/feed.json"
    author: "author"
    authorUrl: "twitter.com/author"
    posts: []
    getPosts: -> []
    urlFor: (post) -> "url/#{post.title()}"

  When -> @subject = new GeneratesJsonFeed(@site)
  When -> @feed = JSON.parse(@subject.generate())
  Then -> @feed.version == "https://jsonfeed.org/version/1.1"
  Then -> @feed.title == "title"
  And -> @feed.description == "description"
  And -> @feed.home_page_url == "url"
  And -> @feed.feed_url == "url/path/feed.json"
  And -> @feed.authors[0].name == "author"
  And -> @feed.authors[0].url == "twitter.com/author"
  And -> @feed.items.length == 0

  context "with posts", ->
    Given -> @site.getPosts = -> [
      {
        title: -> "post1 title"
        content: -> "post1 content"
        description: -> "post1 description"
        time: -> "post1 time"
        rfc3339_time: -> "post1 rfc3339_time"
      },
      {
        title: -> "post2 title"
        content: -> "post2 content"
        description: -> "post2 description"
        time: -> "post2 time"
        rfc3339_time: -> "post2 rfc3339_time"
      }
    ]

    context "feedCount less than number of posts", ->
      Given -> @site.feedCount = 1
      Then -> @feed.items.length == 1
      And -> @feed.items[0].id == "url/post2 title"
      And -> @feed.items[0].url == "url/post2 title"
      And -> @feed.items[0].summary == "post2 description"
      And -> @feed.items[0].date_published == "post2 rfc3339_time"
      And -> @feed.items[0].authors[0].name == "author"
      And -> @feed.items[0].content_html == "post2 content"

    context "feedCount equal to number of posts", ->
      Given -> @site.feedCount = 2
      Then -> @feed.items.length == 2
      And -> @feed.items[0].id == "url/post2 title"
      And -> @feed.items[0].url == "url/post2 title"
      And -> @feed.items[0].summary == "post2 description"
      And -> @feed.items[0].date_published == "post2 rfc3339_time"
      And -> @feed.items[0].authors[0].name == "author"
      And -> @feed.items[0].content_html == "post2 content"
      And -> @feed.items[1].id == "url/post1 title"
      And -> @feed.items[1].url == "url/post1 title"
      And -> @feed.items[1].summary == "post1 description"
      And -> @feed.items[1].date_published == "post1 rfc3339_time"
      And -> @feed.items[1].authors[0].name == "author"
      And -> @feed.items[1].content_html == "post1 content"

    context "feedCount greater than number of posts", ->
      Given -> @site.feedCount = 3
      Then -> @feed.items.length == 2
      Then -> @feed.items.length == 2
      And -> @feed.items[0].id == "url/post2 title"
      And -> @feed.items[0].url == "url/post2 title"
      And -> @feed.items[0].summary == "post2 description"
      And -> @feed.items[0].date_published == "post2 rfc3339_time"
      And -> @feed.items[0].authors[0].name == "author"
      And -> @feed.items[0].content_html == "post2 content"
      And -> @feed.items[1].id == "url/post1 title"
      And -> @feed.items[1].url == "url/post1 title"
      And -> @feed.items[1].summary == "post1 description"
      And -> @feed.items[1].date_published == "post1 rfc3339_time"
      And -> @feed.items[1].authors[0].name == "author"
      And -> @feed.items[1].content_html == "post1 content"
