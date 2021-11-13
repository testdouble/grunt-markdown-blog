GeneratesHtml = require("../lib/generates_html")

describe "GeneratesHtml", ->
  Given ->
    @site = "siteStub"
    @post = "postStub"
    @page = "pageStub"
    @fullHtml = "fullHtmlStub"
    @templateHtml = "templateHtmlStub"
    @wrapper = td.object("wrapper", ["htmlFor"])
    @template = td.object("template", ["htmlFor"])
    @subject = new GeneratesHtml(@site, @wrapper)

  describe "#generate posts", ->
    Given -> td.when(@template.htmlFor({ site: @site, post: @post, page: @post })).thenReturn(@templateHtml)
    Given -> td.when(@wrapper.htmlFor({ site: @site, post: @post, page: @post, yield: @templateHtml })).thenReturn(@fullHtml)
    When -> @resultHtml = @subject.generate(@template, @post)
    Then -> @resultHtml == @fullHtml

  describe "#generate pages", ->
    Given -> td.when(@template.htmlFor({ site: @site, page: @page, post: @page })).thenReturn(@templateHtml)
    Given -> td.when(@wrapper.htmlFor({ site: @site, page: @page, post: @page, yield: @templateHtml })).thenReturn(@fullHtml)
    When -> @resultHtml = @subject.generate(@template, @page)
    Then -> @resultHtml == @fullHtml


