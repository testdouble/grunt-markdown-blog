Post = require './post'

module.exports = class Posts
  timeComparator = (post1, post2) ->
    post1.time().localeCompare(post2.time(), numeric: true)

  @:: = new Array
  constructor: (markdownFiles, {layout, dateFormat, comparator}) ->
    posts = markdownFiles.map (file) -> new Post(file.src[0], file.dest, dateFormat)
    posts.layout = layout
    posts.sort(comparator || timeComparator)
    posts.__proto__ = Posts::
    posts.layout = layout
    return posts

  oldest: ->
    @[0]

  newest: ->
    @[@length - 1]

  htmlFor: (site, post) ->
    @layout.htmlFor {site, post}

  writeHtml: (generatesHtml, writesFile) ->
    for post in @
      html = generatesHtml.generate(@layout, post)
      writesFile.write(html, post.htmlPath())

  older: (post) ->
    @[@indexOf(post) - 1] unless post is @oldest

  newer: (post) ->
    @[@indexOf(post) + 1] unless post is @newest
