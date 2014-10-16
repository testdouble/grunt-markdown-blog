jasmine.constructSpy = (classNameToFake, methodsToSpy = []) ->
  spies = class extends jasmine.createSpy(classNameToFake)
  methodsToSpy.forEach (methodName) ->
    spies::[methodName] = jasmine.createSpy("#{classNameToFake}##{methodName}")
  spies

jasmine.Matchers.ArgThat::jasmineToString = ->
  "<jasmine.argThat(#{@matcher})>"

jasmine.argThatMatches = (expected) ->
  matcher = jasmine.argThat (actual) -> new RegExp(expected).test(actual)
  matcher.jasmineToString = -> "<jasmine.argThatMatches: #{expected}>"
  matcher
