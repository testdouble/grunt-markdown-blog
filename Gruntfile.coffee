#global module:false

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-jasmine-bundle'
  grunt.loadNpmTasks 'grunt-release'

  grunt.initConfig
    spec:
      unit:
        options:
          minijasminenode:
            isVerbose: false
            showColors: true

  grunt.registerTask 'default', ['spec']
