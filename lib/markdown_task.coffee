Factory = require('../lib/factory')
GeneratesHtml = require('../lib/generates_html')
GeneratesRss = require('../lib/generates_rss')
Site = require('../lib/site')
WritesFile = require('../lib/writes_file')

module.exports = class MarkdownTask
  constructor: (@config) ->
    @posts = Factory.postsFrom @config.forPosts()
    @pages = Factory.pagesFrom @config.forPages()
    @index = Factory.indexFrom @posts.newest(), @config.forIndex()
    @archive = Factory.archiveFrom @config.forArchive()
    @feed = Factory.feedFrom @config.forFeed()
    @site = new Site(@config.raw, @posts, @pages)

  run: ->
    writesFile = new WritesFile(@config.destDir())
    wrapper = Factory.siteWrapperFrom @config.forSiteWrapper()
    generatesHtml = new GeneratesHtml(@site, wrapper)

    @posts.writeHtml generatesHtml, writesFile
    @pages.writeHtml generatesHtml, writesFile
    @index.writeHtml generatesHtml, writesFile
    @archive.writeHtml generatesHtml, writesFile

    @feed.writeRss new GeneratesRss(@site), writesFile
