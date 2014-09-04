midonet-schema
==============

`midonet-schema` is the [JSON Schema][json-schema] collection for MidoNet API.
The generated JSON Schemas would be used to generate various clients. See
["The Heroku HTTP API Toolchain"][heroku] to know why JSON Schema.

[json-schema]: http://json-schema.org/
[heroku]: https://blog.heroku.com/archives/2014/5/20/heroku-http-api-toolchain

Prerequisites
-------------

* [prmd (>= 0.3.2)](https://github.com/interagent/prmd)
* [Node.js (>= 0.10.13)](http://nodejs.org/download/)

`midonet-schema` also depends on the npm packages. To install them, please run
the following command at the top level directory of `midonet-schema`.

```bash
$ npm install
```

JSON v.s. CSON
--------------

`midonet-schema` generates JSON Schemas from
[CSON (CoffeeScript Object Notation)][cson] files. JSON is verbose and error-
prone i.e., trailing commas and double quotes. On the other hand, CSON is
compact and easy to write.

However, as an option you can still write schemas in JSON directly. In that case
please put your schemas under `schemata` directory. **Please note those schemas
MUST NOT be conflicted with the CSON schemas. They're overwritten by JSON
shcemas generated from CSON files, otherwise.**

[cson]: https://github.com/bevry/cson

Generating Schema
-----------------

After you write your schema in CSON, please run [Grunt][grunt] task as below.

```bash
$ node_modules/grunt-cli/bin/grunt
```

The generated schemas are placed under `schemata` directory.

If you'd like to combine all schemas into one JSON schema, please run the
followng command.

```bash
$ node_modules/grunt-cli/bin/grunt prmd
```

[grunt]: http://gruntjs.com/


License
-------

`midonet-schema` is released under Midokura Proprietary License.
