SandboxedModule = require('sandboxed-module')
Config = null
grunt = null

beforeEach ->
  Config = SandboxedModule.require '../lib/config',
    requires:
      'grunt': grunt = log: writeln: jasmine.createSpy('grunt-log')

describe "Config", ->
  Given -> @raw = paths: {}
  Given -> @subject = new Config(@raw)

  Invariant -> @raw == @subject.raw

  describe "#forFeed", ->
    When -> @feedConfig = @subject.forFeed()

    context "with rss path", ->
      Given -> @raw.paths.rss = @rssPath = "some/path"

      context "with posts", ->
        Given -> @raw.rssCount = @postCount = 2
        Then -> expect(@feedConfig).toEqual {@rssPath, @postCount}
        And -> expect(grunt.log.writeln).not.toHaveBeenCalled()

      context "without posts", ->
        Given -> @raw.rssCount = @postCount = 0
        Then -> expect(grunt.log.writeln).toHaveBeenCalled()
        And -> @feedConfig.postCount is undefined

    context "without rss path", ->
      Given -> @raw.paths.rss = undefined
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()
      And -> @feedConfig.rssPath is undefined


  describe "#forArchive", ->
    When -> @archiveConfig = @subject.forArchive()

    context "with htmlPath", ->
      Given -> @raw.paths.archive = @htmlPath = "htmlPath"
      Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()
      Then -> expect(@archiveConfig).toEqual {@htmlPath}

    context "without htmlPath", ->
      Given -> @raw.paths.archive = undefined
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()
      Then -> @archiveConfig.htmlPath is undefined

