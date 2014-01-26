module.exports = class Posts
  @:: = new Array
  constructor: (markdownFiles) ->
    markdownFiles.__proto__ = Posts::
    return markdownFiles
