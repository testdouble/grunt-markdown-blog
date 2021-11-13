GeneratesHtml = require("../lib/generates_html")

describe "GeneratesHtml", ->
  Given ->
    @site = "siteStub"
    @post = "postStub"
    @fullHtml = "fullHtmlStub"
    @templateHtml = "templateHtmlStub"
    @wrapper = td.object("wrapper", ["htmlFor"])
    @template = td.object("template", ["htmlFor"])

  describe "#generate", ->
    Given -> td.when(@template.htmlFor({ site: @site, post: @post })).thenReturn(@templateHtml)
    Given -> td.when(@wrapper.htmlFor({ site: @site, post: @post, yield: @templateHtml })).thenReturn(@fullHtml)
    When -> @resultHtml = new GeneratesHtml(@site, @wrapper).generate(@template, @post)
    Then -> @resultHtml == @fullHtml
