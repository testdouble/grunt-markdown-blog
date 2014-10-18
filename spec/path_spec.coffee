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

  describe "#toString", ->
    Given -> @subject = new Path("path/to/file.txt")
    Then -> @subject.toString() == "path/to/file.txt"

