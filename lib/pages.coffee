Page = require './page'
pathlib = require('./maybe_path_lib.coffee')

module.exports = class Pages
  @:: = new Array
  constructor: (markdownFiles, {htmlDir, layout, cwd}) ->
    pages = markdownFiles.map (file) -> new Page(htmlDir, pathlib.join(cwd, file))
    pages.__proto__ = Pages::
    pages.layout = layout
    return pages

  htmlFor: (site, page) ->
    # knowingly set as 'post' for backcompat
    # TODO: deprecate page-as-post in context object
    @layout.htmlFor {site, post: page}

  writeHtml: (generatesHtml, writesFile) ->
    for page in @
      html = generatesHtml.generate(@layout, page)
      writesFile.write(html, page.diskPath())
