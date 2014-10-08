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
        category: "app/templates/category.us"
      process:
        posts: "**/*.md"
        pages: ["**/*.md", "!posts/**/*.md"]
      paths:
        posts:
          src: ["**/*.md"]
          dest: "posts"
          cwd: "app/posts"
          flatten: true
        pages:
          src: ["**/*.md"]
          dest: ""
          cwd: "app/pages"
          flatten: true
        index: "index.html"
        archive: "archive.html"
        rss: "index.xml"
      pathRoots:
        categories: "categories"
        posts: "posts" # unused
        pages: "pages" # unused
      dest: "dist"
      context:
        js: "app.js"
        css: "app.css"
    ).extend(@options(@data))

    new MarkdownTask(config).run()
