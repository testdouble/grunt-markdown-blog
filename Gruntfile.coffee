#global module:false

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-jasmine-bundle'

  grunt.initConfig
    spec:
      unit:
        options:
          minijasminenode:
            isVerbose: true
            showColors: true

  grunt.registerTask 'default', ['spec']
