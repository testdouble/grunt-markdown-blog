global.td = require('testdouble')

jasmine.constructSpy = (classNameToFake, methodsToSpy = []) ->
  spies = class extends jasmine.createSpy(classNameToFake)
  methodsToSpy.forEach (methodName) ->
    spies::[methodName] = jasmine.createSpy("#{classNameToFake}##{methodName}")
  spies
