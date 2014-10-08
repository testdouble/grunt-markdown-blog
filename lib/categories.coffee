Post = require './post'
_ = require('underscore')
_.mixin(require('underscore.string').exports())
path = require("path")

module.exports = class Categories
  timeComparator = (post1, post2) ->
    post1.time().localeCompare(post2.time(), numeric: true)

  @:: = new Array
  constructor: (posts, {htmlDir, layout, dateFormat, comparator}) ->
    categories = []
    posts.sort(comparator || timeComparator)
    posts.forEach (post) ->
      cats = if _.isArray(post.attributes.categories) then post.attributes.categories else []
      cats.forEach (cat) ->
        if (cat and categories.indexOf(cat) == -1)
          categories.push(cat)

    categories.__proto__ = Categories::
    categories.layout = layout
    categories.htmlDir = htmlDir

    return categories

  writeHtml: (generatesHtml, writesFile) ->
    for cat in @
      writesFile.write generatesHtml.generate(@layout, cat), path.join(@htmlDir, _.slugify(cat), "index.html")
