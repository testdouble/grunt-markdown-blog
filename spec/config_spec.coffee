Config = require('../lib/config')

describe "Config", ->
  Given -> @raw = paths: {}
  Given -> @subject = new Config(@raw)

  Invariant -> @raw == @subject.raw

  describe "#forFeed", ->
    Given -> @raw.paths.rss = @rssPath = "some/path"
    Given -> @raw.rssCount = @postCount = 2
    When -> @feedConfig = @subject.forFeed()
    Then -> expect(@feedConfig).toEqual {@rssPath, @postCount}

  # describe "#forArchive", ->
  #   When -> @archiveConfig = @subject.forArchive()

  #   context "with htmlPath", ->
  #     Given -> @raw.paths.archive = @htmlPath = "htmlPath"
  #     Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()
  #     Then -> expect(@archiveConfig).toEqual {@htmlPath}

  #   context "without htmlPath", ->
  #     Given -> @raw.paths.archive = undefined
  #     Then -> expect(grunt.log.writeln).toHaveBeenCalled()
  #     Then -> @archiveConfig.htmlPath is undefined

