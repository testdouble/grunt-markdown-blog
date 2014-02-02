GeneratesHtml = require('../lib/generates_html')

describe "GeneratesHtml", ->
  Given -> @site = "siteStub"
  Given -> @fullHtml = "fullHtmlStub"
  Given -> @wrapper = jasmine.createStubObj("wrapper", htmlFor: @fullHtml)

  describe "#generate", ->
    Given -> @post = "postStub"
    Given -> @templateHtml = "templateHtmlStub"
    Given -> @template = jasmine.createStubObj("template", htmlFor: @templateHtml)

    When -> @resultHtml = new GeneratesHtml(@site, @wrapper).generate(@template, @post)

    Then -> expect(@template.htmlFor).toHaveBeenCalledWith jasmine.argThat (context) =>
        context.site == @site && context.post == @post

    Then -> expect(@wrapper.htmlFor).toHaveBeenCalledWith jasmine.argThat (context) =>
        context.site == @site && context.post == @post && context.yield == @templateHtml

    Then -> @resultHtml == @fullHtml
