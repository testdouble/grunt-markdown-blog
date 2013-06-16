coffeeScript = require('coffee-script')
_ = require('underscore')
grunt = require('grunt')

module.exports = class MarkdownSplitter

  split: (source = "") ->
    inHeader = false
    header = []
    markdown = []
    _(source.split("\n")).each (line) ->
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

# #Used this test to drive out the above. Maybe someday I'll actually wire it up to something
# describe "splitting up markdown files", ->
#   Given -> @subject = new MarkdownSplitter

#   Then -> @subject.split()

#   describe "it evals the header", ->
#     context "javascript", ->
#       Given -> @fixture = """
#                           ---
#                           {
#                             foo: "bar",
#                             baz: 5,
#                             biz: function() { return "beez"; }
#                           }
#                           ---

#                           # My post stuff

#                           Post stuff
#                           """
#       When -> @result = @subject.split(@fixture)
#       Then -> expect(@result.header).toEqual
#         foo: "bar"
#         baz: 5
#         biz: jasmine.argThat (fe) -> fe() == "beez"

#     context "coffeescript", ->
#       Given -> @fixture = """
#                           ---
#                           foo: "bar"
#                           baz: 5
#                           biz: -> "beez"
#                           ---

#                           # My post stuff

#                           Post stuff
#                           """
#       When -> @result = @subject.split(@fixture)
#       Then -> expect(@result.header).toEqual
#         foo: "bar"
#         baz: 5
#         biz: jasmine.argThat (fe) -> fe() == "beez"

#     context "neither", ->
#       Given -> @fixture = """
#                           ---
#                           ¿¡wat?!
#                           ---

#                           # My post stuff

#                           Post stuff
#                           """
#       Then -> expect(=> @subject.split(@fixture)).toThrow()


#   describe "it removes the header", ->
#     Given -> @fixture = """
#                         ---
#                         foo: "bar"
#                         ---

#                         # My post stuff

#                         Post stuff
#                         """
#     When -> @result = @subject.split(@fixture)
#     Then -> expect(@result.markdown.trim()).toEqual """
#                                                     # My post stuff

#                                                     Post stuff
#                                                     """


