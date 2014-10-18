moment = require('moment')
Page = require("./../lib/page")

module.exports = class Post extends Page
  date: ->
    if date = @time()
      moment(date).format(@dateFormat)

  time: ->
    @get('date') || @path.basename().match(/(\d{4}-\d{2}-\d{2})/)?[1] || class MissingDate
