###
Task: markdown
Description: generates HTML files from markdown files for static deployment
Dependencies: grunt, marked
Contributor: @searls
###

module.exports = (grunt) ->
  grunt.registerMultiTask "markdown", "generates HTML from markdown", ->
    MarkdownTask = require('./../lib/markdown_task')
    new MarkdownTask(@options(@data)).run()
