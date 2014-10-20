Path = require('../lib/path')

describe "Path", ->

  describe "#constructor", ->
    Given -> @subject = new Path("some/../path/./to//file.txt")
    Then "normalized", -> @subject.toString() == "path/to/file.txt"

  describe "#basename", ->
    Given -> @subject = new Path("path/to/file.txt")
    Then -> @subject.basename() == "file"

  describe "#dirname", ->
    Given -> @subject = new Path("path/to/file.txt")
    Then -> @subject.dirname() == "path/to"

  describe "#extname", ->
    Given -> @subject = new Path("path/to/file.txt")
    Then -> @subject.extname() == ".txt"

  describe "#filename", ->
    Given -> @subject = new Path("path/to/file.txt")
    Then -> @subject.filename() == "file.txt"

  describe "#changeExtTo", ->
    Given -> @subject = new Path("path/to/file.txt")
    When -> @path = @subject.changeExtTo(".md")
    Then -> @path.toString() == "path/to/file.md"

  describe "#toString", ->
    Given -> @subject = new Path("path/to/file.txt")
    Then -> @subject.toString() == "path/to/file.txt"

  describe "#stripIndex", ->
    When -> @subject = @subject.stripIndex()

    context "with normal path", ->
      Given -> @subject = new Path("path/to/file.text")
      Then -> @subject.toString() == "path/to/file.text"

    context "with index.html ending path", ->
      Given -> @subject = new Path("path/to/index.html")
      Then -> @subject.toString() == "path/to/"
