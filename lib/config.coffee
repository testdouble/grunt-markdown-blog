_ = require('underscore')
grunt = require('grunt')

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
      posts:
        src: "app/posts/**/*.md"
      pages:
        cwd: "app/pages"
        src: "**/*.md"
        dest: "dist"
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

  destDir: ->
    @raw.dest

  forArchive: ->
    destPath: @raw.paths.archive
    layoutPath: @raw.layouts.archive

  forFeed: ->
    destPath: @raw.paths.rss
    postCount: @raw.rssCount

  forIndex: ->
    destPath: @raw.paths.index
    layoutPath: @raw.layouts.index

  forPages: ->
    files: expandFilesMapping(@raw.paths.pages)
    layoutPath: @raw.layouts.page

  forPosts: ->
    files: expandFilesMapping(@raw.paths.posts)
    layoutPath: @raw.layouts.post
    dateFormat: @raw.dateFormat

  forSiteWrapper: ->
    layoutPath: @raw.layouts.wrapper
    context: @raw.context

expandFilesMapping = (mapping) ->
  grunt.task.normalizeMultiTaskFiles(mapping)
