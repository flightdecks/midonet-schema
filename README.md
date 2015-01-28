**This project is based on the old API specification. The old specification is
obsolete and please consult [the latest documenation][spec] if you'd like to
know about the current situation of MidoNet REST API.**

[spec]: https://github.com/midonet/midonet-docs/blob/master/docs/rest-api/src/rest_api.adoc

midonet-schema
==============

`midonet-schema` is a [JSON Schema][json-schema] collection for MidoNet API.
Generated JSON Schemata would be used to generate various clients. See
["The Heroku HTTP API Toolchain"][heroku] to know why JSON Schema was a choice.

[json-schema]: http://json-schema.org/
[heroku]: https://blog.heroku.com/archives/2014/5/20/heroku-http-api-toolchain

Prerequisites
-------------

* [prmd (>= 0.7.0)](https://github.com/interagent/prmd)
* [Node.js (>= 0.10.13)](http://nodejs.org/download/)
    - It should go along with [io.js][iojs] as well but it was never tested

`midonet-schema` also depends on the npm packages. To install them, please run
the following command at the top level directory of `midonet-schema`.

```bash
$ npm install
```

[iojs]: https://iojs.org/

JSON v.s. CSON
--------------

`midonet-schema` generates JSON Schemata from
[CSON (CoffeeScript Object Notation)][cson] files. JSON is verbose and error-
prone i.e., trailing commas and double quotes. On the other hand, CSON is
compact and easy to write. Multi-line string is straightforward [comparing to
YAML][multi-line-yaml].

However, as an option you can still write schemata in JSON directly. In that
case please put your schemas under `schemata` directory. **Please note those
schemata MUST NOT be conflicted with the CSON schemas.** Otherwise, they're
overwritten by JSON shcemata generated from CSON files.

[cson]: https://github.com/bevry/cson
[multi-line-yaml]: http://stackoverflow.com/questions/3790454/

Generating Schemata
-------------------

### With Grunt

After writing your schema in CSON, please run [Grunt][grunt] tasks as below.

```bash
$ node_modules/grunt-cli/bin/grunt
```

Generated schema and Markdown documentation are placed under `schemata`
directory.

If you'd like to watch files and generate schematas automatically, pass `watch`
argument to Grunt.

```bash
$ node_modules/grunt-cli/bin/grunt watch
```

[grunt]: http://gruntjs.com/

### With Gulp

If you prefer [Gulp][gulp], please run the following command.

```bash
$ node_modules/gulp/bin/gulp.js
```

The generated schema and Markdown documentation are placed under `schemata`
directory as well.

Our Gulp configuration also has the `watch` mode.

```bash
$ node_modules/gulp/bin/gulp.js watch
```

[gulp]: http://gulpjs.com/

License
-------

`midonet-schema` is released under [MIT License][mit-license].

[mit-license]: http://opensource.org/licenses/MIT
