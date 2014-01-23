module.exports = class GeneratesHtml
  constructor: (@wrapper, @template, @site) ->

  generate: (post) ->
    context = site: @site, post: post
    context.yield = @template.htmlFor(context)
    @wrapper.htmlFor(context)
