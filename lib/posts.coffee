Post = require './post'

module.exports = class Posts
  @:: = new Array
  constructor: (markdownFiles, {htmlDir, dateFormat}) ->
    posts = markdownFiles.map (file) -> new Post(file, htmlDir, dateFormat)
    posts.__proto__ = Posts::
    return posts
