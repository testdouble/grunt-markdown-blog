Page = null
Pages = null

beforeEach ->
  Page  = td.replace("../lib/page", td.constructor(["fileName"]))
  Pages = require "../lib/pages"

afterEach ->
  td.reset()

describe "Pages", ->
  Given -> @config = td.object("config", ["htmlDir", "layout"])
  Given -> @markdownFiles = [ "page1", "page2" ]
  When -> @subject = new Pages(@markdownFiles, @config)

  describe "has an array of pages", ->
    Then -> @subject.pages.length == 2

  describe "builds pages", ->
    Given -> @markdownFiles = [ @page = td.function("page") ]
    Then -> @subject.pages[0] instanceof Page
    Then -> td.verify(Page(@page, @config.htmlDir))

  describe "#htmlFor", ->
    Given -> @site = "site"
    Given -> @page = "page"
    Given -> @html = "html"
    Given ->
      @config.layout.htmlFor = td.function("layout.htmlFor")
      td.when(@config.layout.htmlFor(site: @site, page: @page)).thenReturn(@html)
    When -> @htmlFor = @subject.htmlFor(@site, @page)
    Then -> @htmlFor == @html

  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = td.object("generatesHtml", ["generate"])
    Given -> @writesFile = td.object("writesFile", ["write"])

    context "without pages", ->
      Given -> @markdownFiles = []
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> td.verify(@generatesHtml.generate(), {times: 0, ignoreExtraArgs: true })
      Then -> td.verify(@writesFile.write(), {times: 0, ignoreExtraArgs: true })

    context "with 3 pages", ->
      Given -> @htmlPath = "htmlPath"
      Given ->
        @page = td.object("page", ["htmlPath"])
        td.when(@page.htmlPath()).thenReturn(@htmlPath)
      When ->
        @subject.pages = [@page, @page, @page]
        @subject.pages.layout = @config.layout
      When ->
        td.when(@generatesHtml.generate(@config.layout, @page)).thenReturn(@html)
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> td.verify(@writesFile.write(@html, @htmlPath), { times: 3})
