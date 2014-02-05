module.exports = class GeneratesHtml
  constructor: (@site, @wrapper) ->

  generate: (template, post) ->
    context = site: @site, post: post
    context.yield = template.htmlFor(context)
    @wrapper.htmlFor(context)
