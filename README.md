midonet-schema
==============

`midonet-schema` is the [JSON schema][json-schema] for MidoNet API. The
generated JSON schemas would be used to generate various clients. See
["The Heroku HTTP API Toolchain"][heroku] to know why JSON schema.

[json-schema]: http://json-schema.org/
[heroku]: https://blog.heroku.com/archives/2014/5/20/heroku-http-api-toolchain

Prerequisites
-------------

* [Node.js (>= 0.10.13)](http://nodejs.org/download/)

`midonet-schema` also depends on the npm packages. To install them, please run
the following command at the top level directory of `midonet-schema`.

```bash
$ npm install
```

JSON v.s. CSON
--------------

`midonet-schema` generates JSON schemas from
[CSON (CoffeeScript Object Notation)][cson] files. JSON is verbose and error-
prone. On the other hand, CSON is compact and easy to write.

However, as an option you can still write schemas in JSON directly. In that case
please put your schemas under `schema` directory. **Please note those schemas
MUST NOT be conflicted with the CSON schemas. They're overwritten by JSON
shcemas generated from CSON files, otherwise.**

[cson]: https://github.com/bevry/cson

Generating Schema
-----------------

After you write your schema in CSON, please run [Grunt][grunt] task as below.

```bash
$ grunt
```

The generated schemas are placed under `schema` directory.

[grunt]: http://gruntjs.com/


License
-------

`midonet-schema` is released under Midokura Proprietary License.
