Markdown = null

beforeEach ->
  @compiler = td.object("compiler", ["parse"])
  @splitter = td.constructor(["split"])
  Markdown = require "../lib/markdown"

afterEach ->
  td.reset()

describe "Markdown", ->
  Given -> @header = "attributes"
  Given -> @markdown = "markdown"

  describe "#compile", ->
    Given -> td.when(@splitter::split(td.matchers.anything())).thenReturn({@header, @markdown})
    Given -> @subject = new Markdown("input source", @compiler, @splitter)
    When -> @subject.compile()
    Then -> @subject.header == @header
    Then -> @subject.source == @markdown
    And  -> td.verify(@compiler.parse(@subject.source))