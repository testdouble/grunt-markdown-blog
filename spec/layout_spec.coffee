Layout = null
NullLayout = null
SandboxedModule = require('sandboxed-module')

Given -> @extendedContext = jasmine.createSpy("extendedContext")
Given -> @layout = jasmine.createSpy("layout").andReturn(@html = jasmine.createSpy("html"))
Given -> Layout = SandboxedModule.require '../lib/layout',
  requires:
    'grunt': @grunt =
      file:
        exists: jasmine.createSpy("grunt.file.exists").andReturn(true)
        read: jasmine.createSpy("grunt.file.read")
    'underscore': @_ = do =>
      _ = jasmine.createSpy("underscore")
      _.mixin = ->
      _.extend = jasmine.createSpy("extend").andReturn(@extendedContext)
      _.template = jasmine.createSpy("template").andReturn(@layout)
      _.andReturn(_)
    './null_layout': NullLayout = jasmine.createSpy("NullLayout")


describe "Layout", ->
  Given -> @templatePath = "somePath.us"
  Given -> @templateContents = "someFileContents"
  Given -> @grunt.file.read.andReturn(@templateContents)
  When -> @subject = new Layout @templatePath, @context

  describe "reads template file", ->
    Then -> expect(@grunt.file.read).toHaveBeenCalledWith @templatePath

  describe "parses file as underscore template", ->
    Then -> expect(@_).toHaveBeenCalledWith @templateContents
    Then -> expect(@_.template).toHaveBeenCalled()

  describe "#htmlFor", ->
    When -> @resultHtml = @subject.htmlFor(@specificContext)

    describe "merges contexts", ->
      Given -> @context = jasmine.createSpy("context")
      Given -> @specificContext = jasmine.createSpy("specificContext")
      Then -> expect(@_).toHaveBeenCalledWith @context
      Then -> expect(@_.extend).toHaveBeenCalledWith @specificContext

    describe "hydrates template with context", ->
      Then -> expect(@layout).toHaveBeenCalledWith @extendedContext
      Then -> @resultHtml == @html

  describe "returns NullLayout for invalid template paths", ->
    Given -> @grunt.file.exists.andReturn(false)
    Then -> @subject instanceof NullLayout
