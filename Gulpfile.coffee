#
# Copyright (c) 2014 Midokura SARL, All Rights Reserved.
#

gulp = require 'gulp'
gcson = require 'gulp-cson'
gshell = require 'gulp-shell'
exec = require 'gulp-exec'

DEST_PREFIX = 'dist/midonet-api-schema'
META_FILE = 'meta.json'
SCHEMATA_DEST = 'schemata'


gulp.task 'cson', ->
  gulp.src '*.cson'
    .pipe gcson()
    .pipe gulp.dest SCHEMATA_DEST

options =
  quiet: false
  ignoreErrors: false

gulp.task 'prmd-combine', ['cson'], gshell.task [
  "prmd combine -m #{META_FILE} #{SCHEMATA_DEST} > #{DEST_PREFIX}.json"
  ], options

gulp.task 'prmd-doc', ['prmd-combine'], ->
  gulp.src("#{DEST_PREFIX}.json", {read: false})
    .pipe exec 'prmd verify <%= file.path %>'
    .pipe exec "perl -pi -e 's/\\\\n/ /g' dist/midonet-api-schema.json"
    .pipe exec 'prmd doc --prepend header.md <%= file.path %> > #{DEST_PREFIX}.md'


gulp.task 'prmd', ['prmd-doc']

gulp.task 'default', ['prmd']
gulp.task 'watch', ->
  gulp.watch '*.cson', ['prmd']
 
