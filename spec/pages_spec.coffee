spy = jasmine.createSpy
Page = null
Pages = null
SandboxedModule = require('sandboxed-module')

beforeEach ->
  Pages = SandboxedModule.require '../lib/pages',
    requires:
      './page': Page = jasmine.constructSpy("Page", ["fileName"])

describe "Pages", ->
  Given -> @config = jasmine.createSpyObj 'config', ['htmlDir', 'layout']
  Given -> @markdownFiles = [ spy(), spy() ]

  When -> @subject = new Pages(@markdownFiles, @config)

  describe "is array-like", ->
    Then -> @subject instanceof Pages
    Then -> @subject instanceof Array
    Then -> @subject.length == 2


  describe "builds pages", ->
    Given -> @markdownFiles = [ @page = spy('page') ]

    Then -> @subject[0] instanceof Page
#    Then -> expect(Page).toHaveBeenCalledWith(@page, @config.htmlDir)


  describe "#htmlFor", ->
    Given -> @site = "site"
    Given -> @page = "page"
    Given -> @html = "html"
    Given -> @config.layout.htmlFor = jasmine.createSpy('layout.htmlFor').andReturn(@html)
    When -> @htmlFor = @subject.htmlFor(@site, @page)
    Then -> expect(@config.layout.htmlFor).toHaveBeenCalledWith(site: @site, post: @page)
    Then -> @htmlFor == @html


  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    context "without pages", ->
      Given -> @markdownFiles = []
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> expect(@generatesHtml.generate).not.toHaveBeenCalled()
      Then -> expect(@writesFile.write).not.toHaveBeenCalled()

    context "with 3 pages", ->
      Given -> @htmlPath = "htmlPath"
      Given -> @page = jasmine.createStubObj('page', diskPath: @htmlPath)
      When -> @subject.splice 0, @subject.length, @page, @page, @page
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> @generatesHtml.generate.callCount == 3
      Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@config.layout, @page)
      Then -> @writesFile.write.callCount == 3
      Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)
