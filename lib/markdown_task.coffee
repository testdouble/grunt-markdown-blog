Factory = require('../lib/factory')
GeneratesHtml = require('../lib/generates_html')
GeneratesRss = require('../lib/generates_rss')
Site = require('../lib/site')
WritesFile = require('../lib/writes_file')

Archive  = require('../lib/archive')
Feeds    = require('../lib/feeds')
Index    = require('../lib/index')
Layout   = require('../lib/layout')
NullFeed = require('../lib/null_feed')
NullHtml = require('../lib/null_html')
Pages    = require('../lib/pages')
Posts    = require('../lib/posts')

module.exports = class MarkdownTask
  constructor: (grunt, @config) ->
    factory = Factory(grunt, { Archive, Feeds, Index, Layout, NullFeed, NullHtml, Pages, Posts })
    @posts = factory.postsFrom @config.forPosts()
    @pages = factory.pagesFrom @config.forPages()
    @index = factory.indexFrom @posts.newest(), @config.forIndex()
    @archive = factory.archiveFrom @config.forArchive()
    @feeds = factory.feedsFrom @config.forFeeds()
    @wrapper = factory.siteWrapperFrom @config.forSiteWrapper()
    @site = new Site(@config.raw, @posts, @pages)

  run: ->
    writesFile = new WritesFile(@config.destDir())
    generatesHtml = new GeneratesHtml(@site, @wrapper)

    @posts.writeHtml generatesHtml, writesFile
    @pages.writeHtml generatesHtml, writesFile
    @index.writeHtml generatesHtml, writesFile
    @archive.writeHtml generatesHtml, writesFile

    @feeds.writeFeeds new GeneratesRss(@site), writesFile
