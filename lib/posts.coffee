Post = require './post'

module.exports = class Posts
  timeComparator = (post1, post2) ->
    post1.time().localeCompare(post2.time(), numeric: true)

  @:: = new Array
  constructor: (markdownFiles, {htmlDir, dateFormat, comparator}) ->
    posts = markdownFiles.map (file) -> new Post(file, htmlDir, dateFormat)
    posts.sort(comparator || timeComparator)
    posts.__proto__ = Posts::
    return posts

  latest: ->
    @[@length - 1]

  writeHtml: (generatesHtml, writesFile) ->
    for post in @
      html = generatesHtml.generate(post)
      writesFile.write(html, post.htmlPath())
