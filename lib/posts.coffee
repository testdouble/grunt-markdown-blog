Post = require './post'

module.exports = class Posts
  fileNameComparator = (post1, post2) ->
    post1.fileName().localeCompare(post2.fileName(), numeric: true)

  @:: = new Array
  constructor: (markdownFiles, {htmlDir, dateFormat, comparator}) ->
    posts = markdownFiles.map (file) -> new Post(file, htmlDir, dateFormat)
    posts.sort(comparator || fileNameComparator)
    posts.__proto__ = Posts::
    return posts
