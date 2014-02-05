grunt = null
NullLayout = null
SandboxedModule = require('sandboxed-module')

beforeEach ->
  NullLayout = SandboxedModule.require '../lib/null_layout',
    requires:
      'grunt': grunt =
        log: error: jasmine.createSpy('grunt-log')
        fail: warn: jasmine.createSpy('grunt-fail')

describe "NullLayout", ->

  When -> @subject = new NullLayout @layoutPath
  When -> @subject.htmlFor()

  context "without layout path", ->
    Given -> @layoutPath = undefined
    Then -> expect(grunt.log.error).toHaveBeenCalled()

  context "with specified but invalid path", ->
    Given -> @layoutPath = "some/missing/file.ext"
    Then -> expect(grunt.fail.warn).toHaveBeenCalled()
