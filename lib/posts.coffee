Post = require './post'

module.exports = class Posts
  constructor: (markdownFiles, {htmlDir, layout, dateFormat, comparator}) ->
    posts = markdownFiles.map (file) -> new Post(file, htmlDir, dateFormat)
    posts.sort(comparator || timeComparator)
    posts.layout = layout
    @posts = posts

  timeComparator = (post1, post2) ->
    post1.time().localeCompare(post2.time(), numeric: true)

  oldest: ->
    @posts[0]

  newest: ->
    @posts[@posts.length - 1]

  htmlFor: (site, post) ->
    @posts.layout.htmlFor {site, post}

  writeHtml: (generatesHtml, writesFile) ->
    for post in @posts
      html = generatesHtml.generate(@posts.layout, post)
      writesFile.write(html, post.htmlPath())

  older: (post) ->
    @posts[@posts.indexOf(post) - 1] unless post is @oldest

  newer: (post) ->
    @posts[@posts.indexOf(post) + 1] unless post is @newest
