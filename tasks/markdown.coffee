module.exports = (grunt) ->
  grunt.registerMultiTask "markdown", "generates HTML from markdown", ->
    Config = require('../lib/config')
    MarkdownTask = require('../lib/markdown_task')
    new MarkdownTask(grunt, new Config(@options(@data))).run()
