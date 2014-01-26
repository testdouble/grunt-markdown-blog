Post = require './post'

module.exports = class Posts
  @:: = new Array
  constructor: (markdownFiles) ->
    posts = markdownFiles.map (file) -> new Post(file)
    posts.__proto__ = Posts::
    return posts
