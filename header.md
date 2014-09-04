MidoNet API Specification
=========================

Introduction
------------

This document specifies a RESTful API for creating and managing MidoNet
resources. The API uses JSON as its format.

Getting Started
---------------

This section is intended to help users get started on using the API.  It assumes
that the MidoNet Management REST API host is known.  This host is represented
as `example.org` in this document. The following GET request to the base URL of
the API reveals the locations of the available resources

    GET /
    Host: example.org
    Accept: application/vnd.org.midonet.Application-v1+json

The request above may yield the following output

    HTTP/1.1 200 OK
    Content-Type: application/vnd.org.midonet.Application-v1+json
    {
        "uri": "http://example.org/",
        "version": "1",
        "bridges": "http://example.org/bridges",
        "chains": "http://example.org/chains",
        "hosts": "http://example.org/hosts",
        "portGroups": "http://example.org/port_groups",
        "routers": "http://example.org/routers",
        "bgpTemplate": "http://example.org/bgps/{id}",
        "adRouteTemplate": "http://example.org/ad_routes/{id}",
        "bridgeTemplate": "http://example.org/bridges/{id}",
        "chainTemplate": "http://example.org/chains/{id}",
        "hostTemplate": "http://example.org/hosts/{id}",
        "portTemplate": "http://example.org/ports/{id}",
        "portGroupTemplate": "http://example.org/port_groups/{id}",
        "routeTemplate": "http://example.org/routes/{id}",
        "routerTemplate": "http://example.org/routers/{id}",
        "ruleTemplate": "http://example.org/rules/{id}"
    }

This reveals that users can access the router resources using the URI
"/routers".  Host resources are accessible with the URI "/hosts".  The response
also includes information about the API version.  The URIs with "{id}" in them
are `uri-templates`, and they are explained later in this document.

Common Behaviors
----------------

This section specifies the common constraints that apply to all the requests
and responses that occur in the MidoNet Management REST API.

### Media Types

In MidoNet REST API, the resources are encoded in JSON, as specified in
RFC 4267.  Each type of resource has its own media-type, which matches the
pattern *application/vnd.org.midonet.xxxxx-v#+json*

where “xxxxx“ represents the unique resource identifier and "#" is the media type's
version number. For most media types the version number will be 1, but several media
types have additional versions. See the sections on individual media types for available
versions. Old versions are provided for backwards compatibility; in general you should
use the newest version available.

When doing a GET on a particular resource, specify the media type in the Accept
header field.  When doing a POST or PUT on a particular resource, specify the
media type in the Content-Type header field.  This also applies when you are
operating on collections as well.


### Request Headers

The following HTTP request headers are relevant to MidoNet REST API:

<table>
  <thead><tr>
    <th>Header</th>
    <th>Supported Values</th>
    <th>Description</th>
    <th>Required</th>
  </tr></thead>
  <tbody valign="top">
    <tr>
      <td>Accept</td>
      <td>Comma-delimited list of media types or media type patterns.</td>
      <td>
        Indicates to the server what media type(s) this client is prepared to
        accept.
      </td>
      <td>No, but recommended</td>
    </tr>
    <tr>
      <td>ContentType</td>
      <td>Media type describing the request message body</td>
      <td>
        Describes the representation and syntax of the request message body.
      </td>
      <td>Yes</td>
    </tr>
  </tbody>
</table>


### Response Headers

The following HTTP response headers exist in MidoNet REST API:

<table>
  <thead>
    <tr>
      <th>Header</th>
      <th>Supported Values</th>
      <th>Description</th>
      <th>Required</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>ContentType</td>
      <td>Media type describingthe response messagebody</td>
      <td>
        Describes the representation and syntax of the response message body
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>Canonical URI of a newly created resource</td>
      <td>
        A new URI that can be used to request a representation of the newly
        created resource
      </td>
      <td>
        Yes, on response that create new server side resources accessible via a
        URI
      </td>
    </tr>
  </tbody>
</table>

### HTTP Status Codes

The following HTTP status codes are returned from MidoNet REST API:

<table>
  <thead>
    <tr>
      <th>HTTP Status</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>200 OK</td>
      <td>
        The request was successfully completed, and the response body contains
        the resource data
      </td>
    </tr>
    <tr>
      <td>201 Created</td>
      <td>
        A new resource was successfully created. A Location header contains the
        URI of the resource
      </td>
    </tr>
    <tr>
      <td>204 No Content</td>
      <td>
        The server fulfilled the request, but does not need to return anything
      </td>
    </tr>
    <tr>
      <td>400 Bad Request</td>
      <td>
        The request could not be processed because it contained missing or
        invalid information
      </td>
    </tr>
    <tr>
      <td>401 Unauthorized</td>
      <td>
        The authentication credentials included with the request are missing or
        invalid
      </td>
    </tr>
    <tr>
      <td>403 Forbidden</td>
      <td>
        The server recognized the credentials, but the user is not authorized to
        perform this request
      </td>
    </tr>
    <tr>
      <td>404 Not Found</td>
      <td>The requested URI does not exist</td>
    </tr>
    <tr>
      <td>405 Method Not Allowed</td>
      <td>
        The HTTP verb specified in the request (GET, POST, PUT, DELETE, HEAD) is
        not supported for this URI
      </td>
    </tr>
    <tr>
      <td>406 Not Acceptable</td>
      <td>
        The resource identified by this request is not capable of generating a
        representation corresponding to one of the media types in the Accept
        header
      </td>
    </tr>
    <tr>
      <td>409 Conflict</td>
      <td>
        A creation or update request could not be completed because it would
        cause a conflict in the current state of the resources. One example is
        when a request attempts to create a resource with an ID that already
        exists
      </td>
    </tr>
    <tr>
      <td>500 Internal Server Error</td>
      <td>
        The server encountered an unexpected condition which prevented the
        request to be completed
      </td>
    </tr>
    <tr>
      <td>503 Service Unavailable</td>
      <td>
        The server is currently unable to handle the request due to temporary
        overloading or maintenance of the server
      </td>
    </tr>
  </tbody>
</table>

### URI Templates

A URI may contain a part that is left out to the client to fill.  These parts
are enclosed inside '{' and '}'.

For example, given a URI template, `http://example.org/routers/{id}` and a
router ID `d7435bb0-3bc8-11e2-81c1-0800200c9a66`, after doing the replacement,
the final URI becomes:
`http://example.org/routers/d7435bb0-3bc8-11e2-81c1-0800200c9a66`.

The following table lists the existing expressions in the URI templates and
what they should be replaced with:

<table>
  <thead>
    <tr>
      <th>Expression</th>
      <th>Replace with</th>
    </tr>
   </thead>
  <tbody>
    <tr>
      <td>id</td>
      <td>Unique identifier of resource</td>
    </tr>
    <tr>
      <td>ipAddr</td>
      <td>IP address</td>
    </tr>
    <tr>
      <td>macAddress</td>
      <td>MAC address</td>
    </tr>
    <tr>
      <td>portId</td>
      <td>Port UUID</td>
    </tr>
    <tr>
      <td>portName</td>
      <td>Port name</td>
    </tr>
    <tr>
      <td>vlanId</td>
      <td>VLAN ID</td>
    </tr>
  </tbody>
</table>

### Methods

#### POST

Used to create a new resource.  The 'Location' header field in the response
contains the URI of the newly created resource.

#### PUT

Used to update an existing resource.

#### GET

Used to retrieve one more more resources.  It could either return a single
object or a collection of objects in the response.

#### DELETE

In MidoNet API, DELETE operation means cascade delete unless noted otherwise.
When a resource is deleted, all of its child resources are also deleted.

Resource Models
---------------

This section specifies the representations of the MidoNet REST API resources.
Each type of resource has its own Internet Media Type. The media type for each
resource is included in square brackets in the corresponding section header.

The 'POST/PUT' column indicates whether the field can be included in the request
with these verbs.  If they are not specified, the field should not be included
in the request.

The Required column indicates is only relevant for POST/PUT operations.
You should not see any entry for 'Required' if the 'POST/PUT' column is
empty. When the Required value is set, it will have indicate whether the
field is relevant for POST, PUT or both. Required fields need to be
included in the request to create/update the object. Note that fields
may be required for PUT but not POST, and viceversa.  In this case it
will be indicated in the specific cell for the field.

Resource Collection
-------------------

A collection of a resource is represented by inserting 'collection' right
before the resource name in the media type.  For example, to get a collection
of Tenants V1 you would represent:

`vnd.org.midonet.Tenant-v1+json`

as:

`vnd.org.midonet.collection.Tenant-v1+json`

See the Query Parameters section of each resource type whether the collection
can be filtered.

Bulk Creation
-------------

The following resources support bulk creation where multiple objects can be
created atomically:

* Neutron Network
* Neutron Subnet
* Neutron Port

The URI for the bulk creation is the same as one used to do single object
creation.  It also expects POST method.  The only difference is that the
Content-Type must be set to the Collection Media Type specified in each of
the resource section above.  These special media types indicate to the API
server that multiple resource objects are being submitted in the request body.


Authentication/Authorization
----------------------------

MidoNet API provides two ways to authenticate: username/password and token.
MidoNet uses [Basic Access Authentication][1] scheme for username/password
authentication. From the client with username 'foo' and password 'bar', the
following HTTP POST request should be sent to '/login' path appended to the
base URI:

    POST    /login
    Authorization: Basic Zm9vOmJhcg==

where `Zm9vOmJhcg==` is the base64 encoded value of `foo:bar`.

If the API sever is configured to use OpenStack Keystone as its authentication
service, then the tenant name given in the web.xml file will be used in the
request sent to the keystone authentication service. However, you can override
this tenant name by specifying it in the request header.

    X-Auth-Project: example_tenant_name

The server returns 401 Unauthorized if the authentication fails, and 200 if
succeeds.  When the login succeeds, the server sets 'Set-Cookie' header with
the generated token and its expiration data as such:

    Set-Cookie: sessionId=baz; Expires=Fri, 02 July 2014 1:00:00 GMT

where 'baz' is the token and 'Wed, 09 Jun 2021 10:18:14 GM' is the expiration
date.  The token can be used for all the subsequent requests until it expires.
Additionally, the content type is set to a Token json type as such:

    Content-Type: application/vnd.org.midonet.Token-v1+json;charset=UTF-8

with the body of the response set to the token information:

    {"key":"baz","expires":"Fri, 02 July 2014 1:00:00 GMT"}

To send a token instead for authentication, the client needs to set it in
`X-Auth-Token` HTTP header:

    X-Auth-Token: baz

The server returns 200 if the token is validated successfully, 401 if the token
was invalid, and 500 if there was a server error.

For authorization, if the requesting user attempts to perform operations or
access resources that it does not have permission to, the API returns 403
Forbidden in the response.  Currently there are only three roles in MidoNet:

* Admin: Superuser that has access to everything
* Tenant Admin: Admin of a tenant that has access to everything that belongs to
  the tenant
* Tenant User: User of a tenant that only has read-only access to resources
  belonging to the tenant

Roles and credentials are set up in the auth service used by the API.

[1]: http://tools.ietf.org/html/rfc2617

List of Acronyms
----------------

* API:  Application Programmable Interface
* BGP:  Border Gateway Protocol
* HTTP:  HyperText Transfer Protocol
* ICMP:  Internet Control Message Protocol
* JSON:  JavaScript Object Notation
* REST:  REpresentational State Transfer
* TOS:  Type Of Service
* URI:  Uniform Resource Identifier
* URL:  Uniform Resource Locator
* VIF:  Virtual Interface
