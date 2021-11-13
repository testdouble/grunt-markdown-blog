Given ->
  MarkdownSplitter = require '../lib/markdown_splitter'
  logger = td.object(['warn'])
  @subject = new MarkdownSplitter(logger)

describe "splitting up markdown files", ->

  Then -> @subject.split()

  describe "it evals the header", ->
    context "javascript", ->
      Given -> @fixture = """
                          ---
                          {
                            foo: "bar",
                            baz: 5,
                            biz: function() { return "beez"; }
                          }
                          ---

                          # My post stuff

                          Post stuff
                          """
      When -> @result = @subject.split(@fixture)
      Then -> expect(@result.header).toEqual
        foo: "bar"
        baz: 5
        biz: jasmine.argThat (fe) -> fe() == "beez"

    context "coffeescript", ->
      Given -> @fixture = """
                          ---
                          foo: "bar"
                          baz: 5
                          biz: -> "beez"
                          ---

                          # My post stuff

                          Post stuff
                          """
      When -> @result = @subject.split(@fixture)
      Then -> expect(@result.header).toEqual
        foo: "bar"
        baz: 5
        biz: jasmine.argThat (fe) -> fe() == "beez"

    context "neither", ->
      Given -> @fixture = """
                          ---
                          ¿¡wat?!
                          ---

                          # My post stuff

                          Post stuff
                          """
      Then -> expect(=> @subject.split(@fixture)).toThrow()


  describe "it removes the header", ->
    Given -> @fixture = """
                        ---
                        foo: "bar"
                        ---

                        # My post stuff

                        Post stuff
                        """
    When -> @result = @subject.split(@fixture)
    Then -> @result.markdown.trim() == """
                                                    # My post stuff

                                                    Post stuff
                                                    """
