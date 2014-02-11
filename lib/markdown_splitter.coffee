coffeeScript = require('coffee-script')
grunt = require('grunt')

module.exports = class MarkdownSplitter

  split: (source = "") ->
    inHeader = false
    header = []
    markdown = []
    source.split("\n").forEach (line) ->
      if line == "---"
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
        grunt.warn(message)
        throw message
