coffeeScript = require('coffeescript')

module.exports = class MarkdownSplitter
  constructor: (@logger = require('grunt')) ->

  split: (source = "") ->
    inHeader = false
    header = []
    markdown = []
    source.replace("\r\n", "\n").split("\n").forEach (line) ->
      if line.trim() == "---"
        inHeader = !inHeader
        return

      return header.push(line) if inHeader
      return markdown.push(line)


    header: @evalHeader(header.join("\n"))
    markdown: markdown.join("\n")

  evalHeader: (source) ->
    try
      headerObject = eval """
                    header = #{source}
                    header
                    """
    catch e
      try
        eval(coffeeScript.compile(source, bare: true))
      catch f
        message = """
                  Failed to evaluate header as either JavaScript or CoffeeScript.

                  JavaScript said:
                  #{e.message}

                  CoffeeScript said:
                  #{f.message}

                  The header source supplied was:
                  ---
                  #{source}
                  ---
                  """
        @logger.warn(message)
        throw message
