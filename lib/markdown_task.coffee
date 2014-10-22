Factory = require('../lib/factory')
GeneratesHtml = require('../lib/generates_html')
GeneratesRss = require('../lib/generates_rss')
Site = require('../lib/site')
WritesFile = require('../lib/writes_file')

module.exports = class MarkdownTask
  constructor: (grunt, @config) ->
    factory = new Factory(grunt)
    @posts = factory.postsFrom @config.forPosts()
    @pages = factory.pagesFrom @config.forPages()
    @index = factory.indexFrom @posts.newest(), @config.forIndex()
    @archive = factory.archiveFrom @config.forArchive()
    @feed = factory.feedFrom @config.forFeed()
    @wrapper = factory.siteWrapperFrom @config.forSiteWrapper()
    @site = new Site(@config.raw, @posts, @pages)

  run: ->
    writesFile = new WritesFile(@config.destDir())
    generatesHtml = new GeneratesHtml(@site, @wrapper)

    @posts.writeHtml generatesHtml, writesFile
    @pages.writeHtml generatesHtml, writesFile
    @index.writeHtml generatesHtml, writesFile
    @archive.writeHtml generatesHtml, writesFile

    @feed.writeRss new GeneratesRss(@site), writesFile
