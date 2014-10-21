_ = require('underscore')

module.exports = class Config
  @defaults:
    author: "Full Name"
    title: "my blog"
    description: "the blog where I write things"
    url: "http://www.myblog.com"
    # disqus: "agile" #<-- define a disqus name for use in your templates
    rssCount: 10
    dateFormat: 'MMMM Do YYYY'
    layouts:
      wrapper: "app/templates/wrapper.us"
      index: "app/templates/index.us"
      post: "app/templates/post.us"
      page: "app/templates/page.us"
      archive: "app/templates/archive.us"
    paths:
      posts: "app/posts/*.md"
      pages: "app/pages/**/*.md"
      index: "index.html"
      archive: "archive.html"
      rss: "index.xml"
    pathRoots:
      posts: "posts"
      pages: "pages"
    dest: "dist"
    context:
      js: "app.js"
      css: "app.css"

  constructor: (@options) ->
    @raw = _({}).extend(@constructor.defaults, @options)

  forArchive: ->
    htmlPath: @raw.paths.archive
    layoutPath: @raw.layouts.archive

  forFeed: ->
    rssPath: @raw.paths.rss
    postCount: @raw.rssCount

  forIndex: ->
    htmlPath: @raw.paths.index
    layoutPath: @raw.layouts.index

  forPages: ->
    htmlDir: @raw.pathRoots.pages
    layoutPath: @raw.layouts.page
    src: ensureCompactArray(@raw.paths.pages)

  forPosts: ->
    src = @raw.paths.markdown || @raw.paths.posts
    htmlDir: @raw.pathRoots.posts
    layoutPath: @raw.layouts.post
    dateFormat: @raw.dateFormat
    src: ensureCompactArray(src)

ensureCompactArray = (val) ->
  [].concat(val).filter (v) -> v
