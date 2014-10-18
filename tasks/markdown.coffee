###
Task: markdown
Description: generates HTML files from markdown files for static deployment
Dependencies: grunt, marked
Contributor: @searls
###

module.exports = (grunt) ->
  grunt.registerMultiTask "markdown", "generates HTML from markdown", ->
    _ = require('underscore')
    MarkdownTask = require('./../lib/markdown_task')

    config = _(
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
    ).extend(@options(@data))

    new MarkdownTask(config).run()
