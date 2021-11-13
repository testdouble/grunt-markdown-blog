module.exports = class GeneratesHtml
  constructor: (@site, @wrapper) ->

  generate: (template, postOrPage) ->
    context = site: @site, post: postOrPage, page: postOrPage
    context.yield = template.htmlFor(context)
    @wrapper.htmlFor(context)
