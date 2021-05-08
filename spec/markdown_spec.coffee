Markdown = null
td = require('testdouble')

describe "Markdown", ->
  Given ->
    @compiler = td.func('compiler')
    @splitter = td.constructor(['split'])
    Markdown = require '../lib/markdown'

  Given -> @header = "attributes"
  Given -> @markdown = "markdown"
  Given -> td.when(@splitter::split(td.matchers.anything())).thenReturn({@header, @markdown})

  describe "#compile", ->
    Given -> @subject = new Markdown("input source", @compiler, @splitter)
    When -> @subject.compile()
    Then -> @subject.header == @header
    Then -> @subject.source == @markdown
    And  -> td.verify(@compiler(@subject.source, td.matchers.isA(Object)))