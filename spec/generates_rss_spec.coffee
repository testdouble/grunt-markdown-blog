Rss = null
GeneratesRss = null
SandboxedModule = require('sandboxed-module')

Given -> Rss = jasmine.constructSpy('Rss', ['item', 'xml'])
Given -> Rss::xml.andReturn(@feedXml = "feedXml")
Given -> GeneratesRss = SandboxedModule.require '../lib/generates_rss', requires: 'rss': Rss

describe "GeneratesRss", ->
  Given -> @site =
    title: "title"
    description: "description"
    url: "url"
    paths:
      rss: "path/feed.xml"
    author: "author"
    posts: []
    urlFor: @urlFor = jasmine.createSpy('site.urlFor').andCallFake (post) -> "url/#{post.title()}"

  When -> @subject = new GeneratesRss @site
  When -> @feed = @subject.generate()
  Then -> expect(Rss).toHaveBeenCalledWith
    title: "title"
    description: "description"
    feed_url: "url/path/feed.xml"
    site_url: "url"
    author: "author"
  Then -> expect(Rss::xml).toHaveBeenCalled()
  Then -> @feed == @feedXml

  context "with no posts", ->
    Given -> @site.posts = []
    Then -> expect(Rss::item).not.toHaveBeenCalled()

  context "with posts", ->
    Given -> @site.posts = [
      @post1 = jasmine.createStubObj 'post1',
        title: "post1 title", content: "post1 content", time: "post1 time"
      @post2 = jasmine.createStubObj 'post2',
        title: "post2 title", content: "post2 content", time: "post2 time"
    ]

    context "rssCount = 0", ->
      Given -> @site.rssCount = 0
      Then -> expect(Rss::item).not.toHaveBeenCalled()

    context "rssCount less than number of posts", ->
      Given -> @site.rssCount = 1
      Then -> Rss::item.callCount == 1
      Then -> expect(Rss::item).toHaveBeenCalledWith
        title: "post1 title", description: "post1 content", url: "url/post1 title", date: "post1 time"

    context "rssCount equal to number of posts", ->
      Given -> @site.rssCount = 2
      Then -> Rss::item.callCount == 2
      Then -> expect(Rss::item).toHaveBeenCalledWith
        title: "post1 title", description: "post1 content", url: "url/post1 title", date: "post1 time"
      Then -> expect(Rss::item).toHaveBeenCalledWith
        title: "post2 title", description: "post2 content", url: "url/post2 title", date: "post2 time"

    context "rssCount greater than number of posts", ->
      Given -> @site.rssCount = 3
      Then -> Rss::item.callCount == 2
      Then -> expect(Rss::item).toHaveBeenCalledWith
        title: "post1 title", description: "post1 content", url: "url/post1 title", date: "post1 time"
      Then -> expect(Rss::item).toHaveBeenCalledWith
        title: "post2 title", description: "post2 content", url: "url/post2 title", date: "post2 time"
