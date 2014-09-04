# Copyright (c) 2014 Midokura SARL, All Rights Reserved.

module.exports = (grunt) ->
  grunt.initConfig
    cson:
      glob_to_multiple:
        expand: true
        src: ['[a-zA-z0-9]*.cson']
        dest: 'schemata'
        ext: '.json'

    watch:
      cson:
        files: ['[a-zA-z0-9]*.cson']
        tasks: ['cson']
        options:
          spawn: false
      prmd:
        files: ['[a-zA-z0-9]*.cson']
        tasks: ['cson', 'shell:prmd']
        options:
          spawn: false

    shell:
      options:
        stderr: false
        stdout: true
        stdin: false
        stdinRawMode: false
      prmd:
        command: [
          'prmd combine -m meta.json schemata
            | tee dist/midonet-api-schema.json
            | prmd verify'
          "perl -pi -e 's/\\\\n/ /g' dist/midonet-api-schema.json"
          'prmd doc --prepend header.md dist/midonet-api-schema.json >
            dist/midonet-api-schema.md'
        ].join '&&'
      clean:
        command: 'rm schemata/*.json'
  
  grunt.loadNpmTasks('grunt-cson')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-shell')
  
  grunt.registerTask('default', ["shell:clean", "cson", 'shell:prmd'])
  grunt.registerTask('watch', ["shell:clean", 'cson', 'watch:cson', 'watch:prmd'])
