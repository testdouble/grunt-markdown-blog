_ = require('underscore')

module.exports = class Config
  @defaults:
    title: "my blog"
    url: "https://www.myblog.com"
    description: "the blog where I write things"
    language: "en" # https://html.spec.whatwg.org/multipage/dom.html#attr-lang
    image: "https://www.myblog.com/image.png"
    favicon: "https://www.myblog.com/favicon.ico"
    dateFormat: 'MMMM Do YYYY'
    rssCount: 10
    author: "Full Name"
    authorUrl: "https://twitter.com/mytwitteraccount"
    layouts:
      wrapper: "app/templates/wrapper.pug"
      index: "app/templates/index.pug"
      post: "app/templates/post.pug"
      page: "app/templates/page.pug"
      archive: "app/templates/archive.pug"
    paths:
      posts: "app/posts/*.md"
      pages: "app/pages/**/*.md"
      index: "index.html"
      archive: "archive.html"
      rss: "index.xml"
      json: "index.json"
    pathRoots:
      posts: "posts"
      pages: "pages"
    dest: "dist"
    context:
      js: "app.js"
      css: "app.css"

  constructor: (@options) ->
    @raw = _({}).extend(@constructor.defaults, @options)

  destDir: ->
    @raw.dest

  forArchive: ->
    htmlPath: @raw.paths.archive
    layoutPath: @raw.layouts.archive

  forFeeds: ->
    rssPath: @raw.paths.rss
    jsonPath: @raw.paths.json
    postCount: @raw.rssCount

  forIndex: ->
    htmlPath: @raw.paths.index
    layoutPath: @raw.layouts.index

  forPages: ->
    htmlDir: @raw.pathRoots.pages
    layoutPath: @raw.layouts.page
    src: ensureCompactArray(@raw.paths.pages)

  forPosts: ->
    src = @raw.paths.posts
    htmlDir: @raw.pathRoots.posts
    layoutPath: @raw.layouts.post
    dateFormat: @raw.dateFormat
    src: ensureCompactArray(src)

  forSiteWrapper: ->
    layoutPath: @raw.layouts.wrapper
    context: @raw.context

ensureCompactArray = (val) ->
  [].concat(val).filter (v) -> v
