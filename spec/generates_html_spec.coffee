GeneratesHtml = require('../lib/generates_html')

describe "GeneratesHtml", ->

  describe "#generate", ->
    Given -> @post = "postStub"
    Given -> @site = "siteStub"
    Given -> @templateHtml = "templateHtmlStub"
    Given -> @fullHtml = "fullHtmlStub"
    Given -> @template = jasmine.createStubObj("template", htmlFor: @templateHtml)
    Given -> @wrapper = jasmine.createStubObj("wrapper", htmlFor: @fullHtml)

    When -> @resultHtml = new GeneratesHtml(@wrapper, @template, @site).generate(@post)

    Then -> expect(@template.htmlFor).toHaveBeenCalledWith jasmine.argThat (context) =>
        context.site == @site && context.post == @post

    Then -> expect(@wrapper.htmlFor).toHaveBeenCalledWith jasmine.argThat (context) =>
        context.site == @site && context.post == @post && context.yield == @templateHtml

    Then -> @resultHtml == @fullHtml
