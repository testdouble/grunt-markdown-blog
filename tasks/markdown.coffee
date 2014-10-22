module.exports = (grunt) ->
  grunt.registerMultiTask "markdown", "generates HTML from markdown", ->
    Config = require('../lib/config')
    MarkdownTask = require('../lib/markdown_task')
    new MarkdownTask(new Config(@options(@data))).run()
