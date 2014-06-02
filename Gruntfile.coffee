module.exports = (grunt) ->
  grunt.initConfig
    cson:
      glob_to_multiple:
        expand: true
        src: ['src/**/*.cson']
        dest: 'schema'
        ext: '.json'
  
  grunt.loadNpmTasks('grunt-cson')
  
  grunt.registerTask('default', ["cson"])
