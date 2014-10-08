moment = require('moment')
Page = require("./../lib/page")

module.exports = class Post extends Page
  date: ->
    if date = @time()
      moment(date).format(@dateFormat)

  time: ->
    @attributes?['date'] || @path.match(/\/(\d{4}-\d{2}-\d{2})/)?[1] || class MissingDate

  excerpt: ->
    @content()?.split("<!-- more -->")[0]