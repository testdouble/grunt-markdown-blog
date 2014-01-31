module.exports = class GeneratesHtml
  constructor: (@site, @wrapper, @template) ->

  generate: (post) ->
    context = site: @site, post: post
    context.yield = @template.htmlFor(context)
    @wrapper.htmlFor(context)
