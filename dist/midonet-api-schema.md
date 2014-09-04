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

## Application
This is the root object in MidoNet REST API. From this object, clients can traverse the URIs to discover all the available services. Neutron was added in v5.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **tenants** | *string* | A GET against this URI gets a list of tenants. | `"http://example.org/midonet-api/tenants"` |
| **version** | *string* | The version of the API server. | `"v1.5"` |
| **bridges** | *string* | A GET against this URI gets a list of bridges. | `"http://example.org/midonet-api/bridges"` |
| **chains** | *string* | A GET against this URI gets a list of chains. | `"http://example.org/midonet-api/chains"` |
| **healthMonitors** | *string* | A GET against this URI gets a list of health monitors. | `"http://example.org/midonet-api/health_monitors"` |
| **hosts** | *string* | A GET against this URI gets a list of hosts. | `"http://example.org/midonet-api/hosts"` |
| **loadBalancers** | *string* | A GET against this URI gets a list of load balancers. | `"http://example.org/midonet-api/load_balancers"` |
| **portGroups** | *string* | A GET against this URI gets a list of port groups. | `"http://example.org/midonet-api/port_groups"` |
| **poolMembers** | *string* | A GET against this URI gets a list of pool members. | `"http://example.org/midonet-api/pool_members"` |
| **pools** | *string* | A GET against this URI gets a list of pools. | `"http://example.org/midonet-api/pools"` |
| **ports** | *string* | A GET against this URI gets a list of ports. | `"http://example.org/midonet-api/ports"` |
| **ipAddrGroups** | *string* | A GET against this URI gets a list of IP address groups. | `"http://example.org/midonet-api/ip_addr_groups"` |
| **routers** | *string* | A GET against this URI gets a list of routers. | `"http://example.org/midonet-api/routers"` |
| **tunnelZone** | *string* | A GET against this URI gets a list of tunnel zones. | `"http://example.org/midonet-api/tunnel_zones"` |
| **vips** | *string* | A GET against this URI gets a list of vips. | `"http://example.org/midonet-api/vips"` |
| **neutron** | *string* | A GET against this URI gets a available Neutron resources. | `"http://example.org/midonet-api/neutron"` |
| **adRouteTemplate** | *string* | Template of the URI that represents the location of BGP with the provided ID. | `"http://example.org/midonet-api/ad_routes/{id}"` |
| **bgpTemplate** | *string* | Template of the URI that represents the location of bridge with the provided ID. | `"http://example.org/midonet-api/bgps/{id}"` |
| **chainTemplate** | *string* | Template of the URI that represents the location of chain with the provided ID. | `"http://example.org/midonet-api/chains/{id}"` |
| **healthMonitorTemplate** | *string* | Template of the URI that represents the location of the health monitor with the provided ID. | `"http://example.org/midonet-api/health_monitors/{id}"` |
| **hostTemplate** | *string* | Template of the URI that represents the location of host with the provided ID. | `"http://example.org/midonet-api/hosts/{id}"` |
| **loadBalancerTmplate** | *string* | Template of the URI that represents the location of the health monitor with the provided ID. | `"http://example.org/midonet-api/load_balancers/{id}"` |
| **portTemplate** | *string* | Template of the URI that represents the location of port with the provided ID. | `"http://example.org/midonet-api/ports/{id}"` |
| **portGroupTemplate** | *string* | Template of the URI that represents the location of port group with the provided ID. | `"http://example.org/midonet-api/port_groups/{id}"` |
| **poolMemberTemplate** | *string* | Template of the URI that represents the location of the pool member with the provided ID. | `"http://example.org/midonet-api/pool_members/{id}"` |
| **poolTemplate** | *string* | Template of the URI that represents the location of the pool with the provided ID. | `"http://example.org/midonet-api/pools/{id}"` |
| **ipAddrGroupTemplate** | *string* | Template of the URI that represents the location of port port group with the provided ID. | `"http://example.org/midonet-api/ip_addr_groups/{id}"` |
| **routeTemplate** | *string* | Template of the URI that represents the location of route with the provided ID. | `"http://example.org/midonet-api/routes/{id}"` |
| **ruleTemplate** | *string* | Template of the URI that represents the location of rule with the provided ID. | `"http://example.org/midonet-api/rules/{id}"` |
| **tenantTemplate** | *string* | Template of the URI that represents the location of tenant with the provided ID. | `"http://example.org/midonet-api/tenants/{id}"` |
| **tunnelZoneTemplate** | *string* | Template of the URI that represents the location of tunnel zone with the provided ID. | `"http://example.org/midonet-api/tunnel_zones/{id}"` |
| **vipTemplate** | *string* | Template of the URI that represents the location of the vip with the provided ID. | `"http://example.org/midonet-api/vips/{id}"` |
### Application Info
A GET against this URI refreshes the representation of this resource.

```
GET /
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "tenants": "http://example.org/midonet-api/tenants",
  "version": "v1.5",
  "bridges": "http://example.org/midonet-api/bridges",
  "chains": "http://example.org/midonet-api/chains",
  "healthMonitors": "http://example.org/midonet-api/health_monitors",
  "hosts": "http://example.org/midonet-api/hosts",
  "loadBalancers": "http://example.org/midonet-api/load_balancers",
  "portGroups": "http://example.org/midonet-api/port_groups",
  "poolMembers": "http://example.org/midonet-api/pool_members",
  "pools": "http://example.org/midonet-api/pools",
  "ports": "http://example.org/midonet-api/ports",
  "ipAddrGroups": "http://example.org/midonet-api/ip_addr_groups",
  "routers": "http://example.org/midonet-api/routers",
  "tunnelZone": "http://example.org/midonet-api/tunnel_zones",
  "vips": "http://example.org/midonet-api/vips",
  "neutron": "http://example.org/midonet-api/neutron",
  "adRouteTemplate": "http://example.org/midonet-api/ad_routes/{id}",
  "bgpTemplate": "http://example.org/midonet-api/bgps/{id}",
  "chainTemplate": "http://example.org/midonet-api/chains/{id}",
  "healthMonitorTemplate": "http://example.org/midonet-api/health_monitors/{id}",
  "hostTemplate": "http://example.org/midonet-api/hosts/{id}",
  "loadBalancerTmplate": "http://example.org/midonet-api/load_balancers/{id}",
  "portTemplate": "http://example.org/midonet-api/ports/{id}",
  "portGroupTemplate": "http://example.org/midonet-api/port_groups/{id}",
  "poolMemberTemplate": "http://example.org/midonet-api/pool_members/{id}",
  "poolTemplate": "http://example.org/midonet-api/pools/{id}",
  "ipAddrGroupTemplate": "http://example.org/midonet-api/ip_addr_groups/{id}",
  "routeTemplate": "http://example.org/midonet-api/routes/{id}",
  "ruleTemplate": "http://example.org/midonet-api/rules/{id}",
  "tenantTemplate": "http://example.org/midonet-api/tenants/{id}",
  "tunnelZoneTemplate": "http://example.org/midonet-api/tunnel_zones/{id}",
  "vipTemplate": "http://example.org/midonet-api/vips/{id}"
}
```


## Route Advertisement
BGP is an entity that represents a single set of BGP configurations.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes/1af56dcd-46c3-49a1-9fd4-3b71691dd863"` |
| **id** | *uuid* | A unique identifier of the resource. | `"1af56dcd-46c3-49a1-9fd4-3b71691dd863"` |
| **bgpId** | *uuid* | ID of the BGP configuration that this route advertisement is configured for. | `"f5963cd4-6abb-4e52-94f6-2dd2a6615365"` |
| **bgp** | *string* | A GET agains this URI gets the BGP resource. | `"http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365"` |
| **nwPrefix** | *ipv4* | The prefix address of the advertising route. | `"1.2.3.4"` |
| **prefixLength** | *integer* | The prefix length of the advertising route.<br/> **Range:** `0 <= value <= 32` | `24` |
### Route Advertisement List
Get the list of route advertisement.

```
GET /bgps/{bgpId}/ad_routes
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bgps/$BGPID/ad_routes

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes/1af56dcd-46c3-49a1-9fd4-3b71691dd863",
    "id": "1af56dcd-46c3-49a1-9fd4-3b71691dd863",
    "bgpId": "f5963cd4-6abb-4e52-94f6-2dd2a6615365",
    "bgp": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365",
    "nwPrefix": "1.2.3.4",
    "prefixLength": 24
  }
]
```

### Route Advertisement Info
Get the specific route advertisement.

```
GET /ad_routes/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ad_routes/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes/1af56dcd-46c3-49a1-9fd4-3b71691dd863",
  "id": "1af56dcd-46c3-49a1-9fd4-3b71691dd863",
  "bgpId": "f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "bgp": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "nwPrefix": "1.2.3.4",
  "prefixLength": 24
}
```

### Route Advertisement Create
Create a new route advertisement.

```
POST /bgps/{bgpId}/ad_routes
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/bgps/$BGPID/ad_routes \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes/1af56dcd-46c3-49a1-9fd4-3b71691dd863",
  "id": "1af56dcd-46c3-49a1-9fd4-3b71691dd863",
  "bgpId": "f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "bgp": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "nwPrefix": "1.2.3.4",
  "prefixLength": 24
}
```

### Route Advertisement Delete
Delete the specific route advertisement.

```
DELETE /ad_routes/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/ad_routes/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes/1af56dcd-46c3-49a1-9fd4-3b71691dd863",
  "id": "1af56dcd-46c3-49a1-9fd4-3b71691dd863",
  "bgpId": "f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "bgp": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "nwPrefix": "1.2.3.4",
  "prefixLength": 24
}
```


## BGP
BGP is an entity that represents a single set of BGP configurations.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365"` |
| **id** | *uuid* | A unique identifier of the resource. | `"f5963cd4-6abb-4e52-94f6-2dd2a6615365"` |
| **portId** | *string* | ID of the port to set the BGP confgurations on. | `"afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
| **port** | *string* | A GET against this URI gets the port resource. | `"http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
| **localAS** | *integer* | Local AS number.<br/> **Range:** `0 <= value <= 65535` | `12345` |
| **peerAS** | *integer* | Peer BGP speaker's AS number.<br/> **Range:** `0 <= value <= 65535` | `12345` |
| **peerAddr** | *ipv4* | The address of the peer to connect to. | `"1.2.3.4"` |
| **adRoutes** | *string* | A GET against this URi retrieves the advertised routes of this BGP speaker. | `"http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes"` |
### BGP List
Get the list of BGPs.

```
GET /ports/{portId}/bgps
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ports/$PORTID/bgps

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365",
    "id": "f5963cd4-6abb-4e52-94f6-2dd2a6615365",
    "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "localAS": 12345,
    "peerAS": 12345,
    "peerAddr": "1.2.3.4",
    "adRoutes": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes"
  }
]
```

### BGP Info
Get the specific BGP.

```
GET /bgps/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bgps/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "id": "f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "localAS": 12345,
  "peerAS": 12345,
  "peerAddr": "1.2.3.4",
  "adRoutes": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes"
}
```

### BGP Create
Create a new BGP.

```
POST /ports/{portId}/bgps
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/ports/$PORTID/bgps \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "id": "f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "localAS": 12345,
  "peerAS": 12345,
  "peerAddr": "1.2.3.4",
  "adRoutes": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes"
}
```

### BGP Delete
Delete the specific BGP.

```
DELETE /bgps/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/bgps/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "id": "f5963cd4-6abb-4e52-94f6-2dd2a6615365",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "localAS": 12345,
  "peerAS": 12345,
  "peerAddr": "1.2.3.4",
  "adRoutes": "http://example.org:8080/midonet-api/bgps/f5963cd4-6abb-4e52-94f6-2dd2a6615365/ad_routes"
}
```


## Bridge
Bridge is an entity that represents a virtual bridge device in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **name** | *string* | Name of the bridge. Must be unique within each tenant. | `"bridge1"` |
| **tenantId** | *uuid* | ID of the tenant that owns the bridge. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **adminStateUp** | *boolean* | The administrative state of the bridge. If false (down), the bridge stops forwarding packets. Default is true (up). | `true` |
| **ports** | *string* | A URI for the resource. | `"http://example.org/"` |
| **dhcpSubnets** | *string* | A URI for the resource. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/arp_table"` |
| **router** | *string* | A GET against this URI retrieves routers on this bridge. | `"http://example.org/"` |
| **macTable** | *string* | A GET against this URI retrieves the bridge's MAC table. | `"http://example.org/"` |
| **peerPorts** | *string* | A GET against this URI retrieves the interior ports attached to this bridge. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/peers"` |
| **inboundFilterId** | *uuid* | ID of the filter chain to be applied for incoming packes. | `"cc15564b-2f0b-4579-8b4b-06c0687a7240"` |
| **inboundFilter** | *string* | A GET against this URI retrieves the inbound filter chain. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/inboundFileter"` |
| **outboundFilterId** | *uuid* | ID of the filter chain to be applied for outgoing packets. | `"cc15564b-2f0b-4579-8b4b-06c0687a7240"` |
| **outboundFilter** | *string* | A GET against this URI retreives the outbound filter chain. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/outboundFileter"` |
| **vxlanPort** | *string* | A GET against this URI retrieves the VXLAN port. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/vxlanPort"` |
### Bridge List
Get the list of bridges.

```
GET /bridges
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
    "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "name": "bridge1",
    "tenantId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "adminStateUp": true,
    "ports": "http://example.org/",
    "dhcpSubnets": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/arp_table",
    "router": "http://example.org/",
    "macTable": "http://example.org/",
    "peerPorts": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/peers",
    "inboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
    "inboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/inboundFileter",
    "outboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
    "outboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/outboundFileter",
    "vxlanPort": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/vxlanPort"
  }
]
```

### Bridge Info
Get the specific bridge.

```
GET /bridges/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "name": "bridge1",
  "tenantId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "adminStateUp": true,
  "ports": "http://example.org/",
  "dhcpSubnets": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/arp_table",
  "router": "http://example.org/",
  "macTable": "http://example.org/",
  "peerPorts": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/peers",
  "inboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "inboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/inboundFileter",
  "outboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "outboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/outboundFileter",
  "vxlanPort": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/vxlanPort"
}
```

### Bridge Create
Create a new bridge.

```
POST /bridges
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/bridges \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "name": "bridge1",
  "tenantId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "adminStateUp": true,
  "ports": "http://example.org/",
  "dhcpSubnets": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/arp_table",
  "router": "http://example.org/",
  "macTable": "http://example.org/",
  "peerPorts": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/peers",
  "inboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "inboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/inboundFileter",
  "outboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "outboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/outboundFileter",
  "vxlanPort": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/vxlanPort"
}
```

### Bridge Update
Update the specific bridge.

```
PUT /bridges/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/bridges/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "name": "bridge1",
  "tenantId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "adminStateUp": true,
  "ports": "http://example.org/",
  "dhcpSubnets": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/arp_table",
  "router": "http://example.org/",
  "macTable": "http://example.org/",
  "peerPorts": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/peers",
  "inboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "inboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/inboundFileter",
  "outboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "outboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/outboundFileter",
  "vxlanPort": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/vxlanPort"
}
```

### Bridge Delete
Delete the specific bridge.

```
DELETE /bridges/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/bridges/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "name": "bridge1",
  "tenantId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "adminStateUp": true,
  "ports": "http://example.org/",
  "dhcpSubnets": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/arp_table",
  "router": "http://example.org/",
  "macTable": "http://example.org/",
  "peerPorts": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/peers",
  "inboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "inboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/inboundFileter",
  "outboundFilterId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "outboundFilter": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/outboundFileter",
  "vxlanPort": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/vxlanPort"
}
```


## Chain
Chain is an entity that represents a rule chain on a virtual router in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240"` |
| **id** | *uuid* | A unique identifier of the resource. | `"cc15564b-2f0b-4579-8b4b-06c0687a7240"` |
| **tenantId** | *uuid* | ID of the tenant that this chain belongs to. | `"7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
| **name** | *string* | Name of the chain. Unique per tenant. | `"example_chain"` |
| **rules** | *string* | A GET against this URI retrieves the representation of the rules set for this chain. | `"http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240/rules"` |
### Chain List
Get the list of chains.

```
GET /chains
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/chains

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240",
    "id": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
    "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "name": "example_chain",
    "rules": "http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240/rules"
  }
]
```

### Chain Info
Get the specific chain.

```
GET /chains/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/chains/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "id": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "name": "example_chain",
  "rules": "http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240/rules"
}
```

### Chain Create
Create a new router.

```
POST /chains
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/chains \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "id": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "name": "example_chain",
  "rules": "http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240/rules"
}
```

### Chain Delete
Delete the specific chain.

```
DELETE /chains/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/chains/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "id": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "name": "example_chain",
  "rules": "http://example.org:8080/midonet-api/chains/cc15564b-2f0b-4579-8b4b-06c0687a7240/rules"
}
```



## DHCP Host
DHCP Subnet is an entity that represents an entry of the virtual DHCP table in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d"` |
| **ipAddress** | *ipv4* | IPv4 address of the host in the form 1.2.3.4. | `"1.2.3.4"` |
| **macAddress** | *string* | MAC Address of the host in the form AA.BB.CC.DD.EE.FF.<br/> **pattern:** <code>^((?:[0-9a-f]{2}:){5}[0-9a-f]{2}&#124;(?:[0-9A-F]{2}:){5}[0-9A-F]{2})$</code> | `"aa:bb:cc:dd:ee:ff"` |
### DHCP Host List
Get the list of IP4MacPair.

```
GET /bridges/{bridgeId}/arp_table
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/arp_table

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
    "ipAddress": "1.2.3.4",
    "macAddress": "aa:bb:cc:dd:ee:ff"
  }
]
```

### DHCP Host Info
Get the specific bridge.

```
GET /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ipAddress": "1.2.3.4",
  "macAddress": "aa:bb:cc:dd:ee:ff"
}
```

### DHCP Host Create
Create a new bridge.

```
POST /bridges/{bridgeId}/arp_table
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/bridges/$BRIDGEID/arp_table \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ipAddress": "1.2.3.4",
  "macAddress": "aa:bb:cc:dd:ee:ff"
}
```

### DHCP Host Update
Update the specific bridge.

```
PUT /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ipAddress": "1.2.3.4",
  "macAddress": "aa:bb:cc:dd:ee:ff"
}
```

### DHCP Host Delete
Delete the specific bridge.

```
DELETE /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ipAddress": "1.2.3.4",
  "macAddress": "aa:bb:cc:dd:ee:ff"
}
```


## DHCP Subnet
DHCP Subnet is an entity that represents an entry of the virtual DHCP table in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d"` |
| **ip** | *ipv4* | IP version 4 address in the form 1.2.3.4. | `"1.2.3.4"` |
| **macPortPair** | *string* | Consists of a MAC address in the form 12-34-56-78-9a-bc and the destination port's ID, separated by an underscore. For example: 12-34-56-78-9a-bc_01234567-89ab-cdef-0123-4567890abcdef. |  |
### DHCP Subnet List
Get the list of IP4MacPair.

```
GET /bridges/{bridgeId}/arp_table
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/arp_table

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
    "ip": "1.2.3.4",
    "macPortPair": null
  }
]
```

### DHCP Subnet Info
Get the specific bridge.

```
GET /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ip": "1.2.3.4",
  "macPortPair": null
}
```

### DHCP Subnet Create
Create a new bridge.

```
POST /bridges/{bridgeId}/arp_table
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/bridges/$BRIDGEID/arp_table \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ip": "1.2.3.4",
  "macPortPair": null
}
```

### DHCP Subnet Update
Update the specific bridge.

```
PUT /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ip": "1.2.3.4",
  "macPortPair": null
}
```

### DHCP Subnet Delete
Delete the specific bridge.

```
DELETE /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ip": "1.2.3.4",
  "macPortPair": null
}
```


## HealthMonitor
A HealthMonitor is an entity that represents a virtual health monitor device for use with load balancers in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/health_monitors/7a35950e-09cb-4ed1-ba20-cb6864e7e035"` |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"7a35950e-09cb-4ed1-ba20-cb6864e7e035"` |
| **delay** | *integer* | Delay for the health check interval in seconds. Defaults to 0.<br/> **Range:** `0 <= value` | `10` |
| **timeout** | *integer* | Timeout value for the health check in seconds. Defaults to 0.<br/> **Range:** `0 <= value` | `10` |
| **maxRetries** | *integer* | Number of times to retry for health check. Defaults to 0.<br/> **Range:** `0 <= value` | `10` |
| **type** | *string* | A type of the health monitor checking protocol. Only "TCP" is supported in the current version. Read-only property.<br/> **one of:**`"TCP"` | `"TCP"` |
| **adminStateUp** | *boolean* | The administrative state of the resource. | `true` |
| **status** | *string* | The status of the object. There are following states:    * ACTIVE   * INACTIVE<br/> **one of:**`"ACTIVE"` or `"INACTIVE"` | `"ACTIVE"` |
| **pools** | *string* | A GET against this URI retrieves the pools. | `"http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools"` |
### HealthMonitor List
Get the list of health monitors

```
GET /health_monitors
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/health_monitors

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/health_monitors/7a35950e-09cb-4ed1-ba20-cb6864e7e035",
    "id": "7a35950e-09cb-4ed1-ba20-cb6864e7e035",
    "delay": 10,
    "timeout": 10,
    "maxRetries": 10,
    "type": "TCP",
    "adminStateUp": true,
    "status": "ACTIVE",
    "pools": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools"
  }
]
```

### HealthMonitor Info
Get the specific health monitor.

```
GET /health_monitors/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/health_monitors/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/health_monitors/7a35950e-09cb-4ed1-ba20-cb6864e7e035",
  "id": "7a35950e-09cb-4ed1-ba20-cb6864e7e035",
  "delay": 10,
  "timeout": 10,
  "maxRetries": 10,
  "type": "TCP",
  "adminStateUp": true,
  "status": "ACTIVE",
  "pools": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools"
}
```

### HealthMonitor Create
Create a new health monitor.

```
POST /health_monitors
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/health_monitors \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/health_monitors/7a35950e-09cb-4ed1-ba20-cb6864e7e035",
  "id": "7a35950e-09cb-4ed1-ba20-cb6864e7e035",
  "delay": 10,
  "timeout": 10,
  "maxRetries": 10,
  "type": "TCP",
  "adminStateUp": true,
  "status": "ACTIVE",
  "pools": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools"
}
```

### HealthMonitor Update
Update the specific health monitor.

```
PUT /health_monitors/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/health_monitors/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/health_monitors/7a35950e-09cb-4ed1-ba20-cb6864e7e035",
  "id": "7a35950e-09cb-4ed1-ba20-cb6864e7e035",
  "delay": 10,
  "timeout": 10,
  "maxRetries": 10,
  "type": "TCP",
  "adminStateUp": true,
  "status": "ACTIVE",
  "pools": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools"
}
```

### HealthMonitor Delete
Delete the specific health monitor.

```
DELETE /health_monitors/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/health_monitors/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/health_monitors/7a35950e-09cb-4ed1-ba20-cb6864e7e035",
  "id": "7a35950e-09cb-4ed1-ba20-cb6864e7e035",
  "delay": 10,
  "timeout": 10,
  "maxRetries": 10,
  "type": "TCP",
  "adminStateUp": true,
  "status": "ACTIVE",
  "pools": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools"
}
```


## Host
Host is an entity that provides some information about a cluster node.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **id** | *uuid* | A unique identifier of the resource. It is usually autogenerated by the daemon running on the host. | `"07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **name** | *string* | The last seen host name. | `"example_host"` |
| **alive** | *boolean* | Return true if the node-agent running on the host is connected to ZK. | `true` |
| **addresses** | *array* | The of last seen ip addresses visible on the host. | `["10.0.0.1","10.0.0.2"]` |
| **interfaces** | *string* | A GET against this URI gets the interface names on this host. | `"http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces"` |
| **ports** | *string* | A GET against this URI gets the virtual ports bound to the interfaces on this host. | `"http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/ports"` |
### Host List
Get the list of hosts.

```
GET /hosts
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/hosts

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
    "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
    "name": "example_host",
    "alive": true,
    "addresses": [
      "10.0.0.1",
      "10.0.0.2"
    ],
    "interfaces": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces",
    "ports": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/ports"
  }
]
```

### Host Info
Get the specific host.

```
GET /hosts/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/hosts/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "name": "example_host",
  "alive": true,
  "addresses": [
    "10.0.0.1",
    "10.0.0.2"
  ],
  "interfaces": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces",
  "ports": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/ports"
}
```

### Host Update
Update the specific host.

```
PUT /hosts/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/hosts/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "name": "example_host",
  "alive": true,
  "addresses": [
    "10.0.0.1",
    "10.0.0.2"
  ],
  "interfaces": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces",
  "ports": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/ports"
}
```

### Host Delete
Delete the specific host.

```
DELETE /hosts/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/hosts/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "name": "example_host",
  "alive": true,
  "addresses": [
    "10.0.0.1",
    "10.0.0.2"
  ],
  "interfaces": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces",
  "ports": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/ports"
}
```


## Host Command
This is the description of the command generated by an Interface PUT operation. For each host there is going to be a list of HostCommand objects intended to be executed sequentially to make sure that the local host configuration is kept up to date.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834"` |
| **id** | *uuid* | A unique identifier of the resource. It is usually autogenerated by the daemon running on the host. | `"16cf6e04-0d24-4abd-b81a-9e650e186834"` |
| **hostId** | *uuid* | The unique identifier of the host that is the target of this command. | `"07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **interfaceName** | *string* | The name of the interface targeted by this command. | `"example_interface"` |
| **commands** | *array* | Each Command has three properties: [operation, property, value]. The operation can be one of: SET, DELETE, CLEAR. The property can be one of: mtu, address, mac, interface, midonet_port_id. The value is the value of the operation as a string. | `[{"operation":"SET","property":"mtu","value":"1500"},{"operation":"DELETE","property":"mac","value":null},{"operation":"CLEAR","property":"midonet_port_id","value":null}]` |
| **logEntries** | *array* | A log entry contains a timestamp (which is a unix time long) and a string which is the error message that was generated at the moment. | `[{"timestamp":null,"error":""},{"timestamp":null,"error":""}]` |
### Host Command List
Get the list of host commands.

```
GET /hosts/{hostId}/commands
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/hosts/$HOSTID/commands

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834",
    "id": "16cf6e04-0d24-4abd-b81a-9e650e186834",
    "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
    "interfaceName": "example_interface",
    "commands": [
      {
        "operation": "SET",
        "property": "mtu",
        "value": "1500"
      },
      {
        "operation": "DELETE",
        "property": "mac",
        "value": null
      },
      {
        "operation": "CLEAR",
        "property": "midonet_port_id",
        "value": null
      }
    ],
    "logEntries": [
      {
        "timestamp": null,
        "error": ""
      },
      {
        "timestamp": null,
        "error": ""
      }
    ]
  }
]
```

### Host Command Info
Get the specific host command.

```
GET /hosts/{hostId}/commands/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/hosts/$HOSTID/commands/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834",
  "id": "16cf6e04-0d24-4abd-b81a-9e650e186834",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "interfaceName": "example_interface",
  "commands": [
    {
      "operation": "SET",
      "property": "mtu",
      "value": "1500"
    },
    {
      "operation": "DELETE",
      "property": "mac",
      "value": null
    },
    {
      "operation": "CLEAR",
      "property": "midonet_port_id",
      "value": null
    }
  ],
  "logEntries": [
    {
      "timestamp": null,
      "error": ""
    },
    {
      "timestamp": null,
      "error": ""
    }
  ]
}
```

### Host Command Delete
Delete the specific host command.

```
DELETE /hosts/{hostId}/commands/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/hosts/$HOSTID/commands/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834",
  "id": "16cf6e04-0d24-4abd-b81a-9e650e186834",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "interfaceName": "example_interface",
  "commands": [
    {
      "operation": "SET",
      "property": "mtu",
      "value": "1500"
    },
    {
      "operation": "DELETE",
      "property": "mac",
      "value": null
    },
    {
      "operation": "CLEAR",
      "property": "midonet_port_id",
      "value": null
    }
  ],
  "logEntries": [
    {
      "timestamp": null,
      "error": ""
    },
    {
      "timestamp": null,
      "error": ""
    }
  ]
}
```


## Host Interface Port
The HostInterfacePort binding allows mapping a virtual network port to an interface (virtual or physical) of a physical host where Midolman is running.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834"` |
| **hostIdd** | *uuid* | A unique identifier of the host resource. It is usually autogenerated by the daemon running on the host. | `"07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **interfaceName** | *string* | The interface physical name. | `"example_interface"` |
| **portId** | *uuid* | A unique identifier of the port resource. | `"afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
### Host Interface Port List
Get the list of host interface ports.

```
GET /hosts/{hostId}/ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/hosts/$HOSTID/ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834",
    "hostIdd": "07743a54-fd7d-430e-b7b1-320843b005e3",
    "interfaceName": "example_interface",
    "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8"
  }
]
```

### Host Interface Port Info
Get the specific host interface port.

```
GET /hosts/{hostId}/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/hosts/$HOSTID/ports/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834",
  "hostIdd": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "interfaceName": "example_interface",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Host Interface Port Create
Create a new host interface port

```
POST /hosts/{hostId}/ports
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/hosts/$HOSTID/ports \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834",
  "hostIdd": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "interfaceName": "example_interface",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Host Interface Port Update
Update the specific host interface port.

```
PUT /hosts/{hostId}/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/hosts/$HOSTID/ports/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834",
  "hostIdd": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "interfaceName": "example_interface",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Host Interface Port Delete
Delete the specific host interface port.

```
DELETE /hosts/{hostId}/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/hosts/$HOSTID/ports/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/commands/16cf6e04-0d24-4abd-b81a-9e650e186834",
  "hostIdd": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "interfaceName": "example_interface",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```


## Host Version
The Host Version specifies version information for each host running in the Midonet deployment.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **version** | *string* | The version of Midolman agent running on the host.<br/> **pattern:** <code>^d+.d+$</code> | `"1.6"` |
| **hostId** | *uuid* | The the UUID of the host that the Midolman agent is running on. | `"07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **host** | *string* | The URI of the host that the Midolman agent is running on. | `"http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3"` |
### Host Version Info
Get the specific VTEP.

```
GET /versions
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/versions

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "version": "1.6",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3"
}
```


## Interface
The interface is an entity abstracting information about a physical interface associated with a host.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces/af7c74ec-913c-4974-90b2-188e48ba3532"` |
| **hostId** | *uuid* | The unique identifier of the host that owns this interface. | `"af7c74ec-913c-4974-90b2-188e48ba3532"` |
| **name** | *string* | The interface physical name. | `"example_interface"` |
| **mac** | *string* | The interface physical address (MAX).<br/> **pattern:** <code>^((?:[0-9a-f]{2}:){5}[0-9a-f]{2}&#124;(?:[0-9A-F]{2}:){5}[0-9A-F]{2})$</code> | `"aa:bb:cc:dd:ee:ff"` |
| **mtu** | *integer* | The interface MTU value.<br/> **Range:** `0 <= value` | `1500` |
| **status** | *integer* | Bitmask of status flags. Currently we provide information about UP status and Carrier status (0x01, 0x02 respectively)<br/> **one of:**`1` or `2` | `1` |
| **type** | *string* | Interface type (the best information that we have been able to infer). Can be: Unknown | Physical | Virtual | Tunnel<br/> **one of:**`"Unknown"` or `"Physical"` or `"Virtual"` or `"Tunnel"` | `"Physical"` |
| **addresses** | *array* | The list of inet addresses bound to this interface. | `["10.0.0.1","10.0.0.2"]` |
### Interface List
Get the list of interfaces.

```
GET /hosts/{hostId}/interfaces
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/hosts/$HOSTID/interfaces

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces/af7c74ec-913c-4974-90b2-188e48ba3532",
    "hostId": "af7c74ec-913c-4974-90b2-188e48ba3532",
    "name": "example_interface",
    "mac": "aa:bb:cc:dd:ee:ff",
    "mtu": 1500,
    "status": 1,
    "type": "Physical",
    "addresses": [
      "10.0.0.1",
      "10.0.0.2"
    ]
  }
]
```

### Interface Info
Get the specific interface.

```
GET /hosts/{hostId}/interfaces/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/hosts/$HOSTID/interfaces/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces/af7c74ec-913c-4974-90b2-188e48ba3532",
  "hostId": "af7c74ec-913c-4974-90b2-188e48ba3532",
  "name": "example_interface",
  "mac": "aa:bb:cc:dd:ee:ff",
  "mtu": 1500,
  "status": 1,
  "type": "Physical",
  "addresses": [
    "10.0.0.1",
    "10.0.0.2"
  ]
}
```

### Interface Create
Create a new interface.

```
POST /hosts/{hostId}/interfaces
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/hosts/$HOSTID/interfaces \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces/af7c74ec-913c-4974-90b2-188e48ba3532",
  "hostId": "af7c74ec-913c-4974-90b2-188e48ba3532",
  "name": "example_interface",
  "mac": "aa:bb:cc:dd:ee:ff",
  "mtu": 1500,
  "status": 1,
  "type": "Physical",
  "addresses": [
    "10.0.0.1",
    "10.0.0.2"
  ]
}
```

### Interface Update
Update the specific interface.

```
PUT /hosts/{hostId}/interfaces/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/hosts/$HOSTID/interfaces/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3/interfaces/af7c74ec-913c-4974-90b2-188e48ba3532",
  "hostId": "af7c74ec-913c-4974-90b2-188e48ba3532",
  "name": "example_interface",
  "mac": "aa:bb:cc:dd:ee:ff",
  "mtu": 1500,
  "status": 1,
  "type": "Physical",
  "addresses": [
    "10.0.0.1",
    "10.0.0.2"
  ]
}
```


## IP4MacPair
IP4MacPair is an entity that represents an entry of the virtual ARP table in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d"` |
| **ip** | *ipv4* | IP version 4 address in the form 1.2.3.4. | `"1.2.3.4"` |
| **mac** | *string* | A MAC address in the form aa:bb:cc:dd:ee:ff. If ARP replies are enabled on the bridge, the ip will resolve to this MAC.<br/> **pattern:** <code>^((?:[0-9a-f]{2}:){5}[0-9a-f]{2}&#124;(?:[0-9A-F]{2}:){5}[0-9A-F]{2})$</code> | `"aa:bb:cc:dd:ee:ff"` |
### IP4MacPair List
Get the list of IP4MacPair.

```
GET /bridges/{bridgeId}/arp_table
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/arp_table

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
    "ip": "1.2.3.4",
    "mac": "aa:bb:cc:dd:ee:ff"
  }
]
```

### IP4MacPair Info
Get the specific bridge.

```
GET /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ip": "1.2.3.4",
  "mac": "aa:bb:cc:dd:ee:ff"
}
```

### IP4MacPair Create
Create a new bridge.

```
POST /bridges/{bridgeId}/arp_table
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/bridges/$BRIDGEID/arp_table \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ip": "1.2.3.4",
  "mac": "aa:bb:cc:dd:ee:ff"
}
```

### IP4MacPair Update
Update the specific bridge.

```
PUT /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ip": "1.2.3.4",
  "mac": "aa:bb:cc:dd:ee:ff"
}
```

### IP4MacPair Delete
Delete the specific bridge.

```
DELETE /bridges/{bridgeId}/arp_table/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/bridges/$BRIDGEID/arp_table/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/bridges/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/mac_table/95b74631-a87d-49c7-8cbc-e2f8ff7ddd9d",
  "ip": "1.2.3.4",
  "mac": "aa:bb:cc:dd:ee:ff"
}
```


## IP Address Group
IP address group is a group of IP addresss. Currently only IPv4 is supported. An IP address group can be specified in the chain rule to filter the traffic coming from all the addresses belonging to that the specified group.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae"` |
| **id** | *uuid* | A unique identifier of the resource. | `"a7d05156-5212-409c-9276-b0a1b4ac5eae"` |
| **name** | *string* | Name of the group. | `"example_ip_address_group"` |
| **addrs** | *string* | URI for address membership operations. | `"http://example.org/"` |
### IP Address Group List
Get the list of IP address groups.

```
GET /ip_addr_groups
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ip_addr_groups

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
    "id": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
    "name": "example_ip_address_group",
    "addrs": "http://example.org/"
  }
]
```

### IP Address Group Info
Get the specific IP address group.

```
GET /ip_addr_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ip_addr_groups/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "id": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "name": "example_ip_address_group",
  "addrs": "http://example.org/"
}
```

### IP Address Group Create
Create a new IP address group.

```
POST /ip_addr_groups
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/ip_addr_groups \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "id": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "name": "example_ip_address_group",
  "addrs": "http://example.org/"
}
```

### IP Address Group Update
Update the specific IP address group.

```
PUT /ip_addr_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/ip_addr_groups/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "id": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "name": "example_ip_address_group",
  "addrs": "http://example.org/"
}
```

### IP Address Group Delete
Delete the specific IP address group.

```
DELETE /ip_addr_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/ip_addr_groups/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "id": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "name": "example_ip_address_group",
  "addrs": "http://example.org/"
}
```


## IP Address Group Address
IpAddrGroupAddr represents membership of IP address in IP address groups.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae/ip_addrs/229b39e5-ff1c-4f0f-9d91-9adf6122d423"` |
| **id** | *uuid* | A unique identifier of the resource. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **ipAddrGroupId** | *uuid* | ID of the IP address group that this IP address is a member of. | `"a7d05156-5212-409c-9276-b0a1b4ac5eae"` |
| **ipAddrGroup** | *string* | URI to fetch the IP address group. | `"http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae"` |
| **addr** | *ipv4* | IP Address member in an IP address group. | `"1.2.3.4"` |
### IP Address Group Address List
Get the list of IP address group addresses.

```
GET /ip_addr_groups/{ipAddrGroupId}/version/4/ip_addrs
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ip_addr_groups/$IPADDRGROUPID/version/4/ip_addrs

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae/ip_addrs/229b39e5-ff1c-4f0f-9d91-9adf6122d423",
    "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "ipAddrGroupId": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
    "ipAddrGroup": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
    "addr": "1.2.3.4"
  }
]
```

### IP Address Group Address Info
Get the specific IP address group address.

```
GET /ip_addr_groups/{ipAddrGroupId}/ip_addrs/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ip_addr_groups/$IPADDRGROUPID/ip_addrs/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae/ip_addrs/229b39e5-ff1c-4f0f-9d91-9adf6122d423",
  "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "ipAddrGroupId": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "ipAddrGroup": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "addr": "1.2.3.4"
}
```

### IP Address Group Address Create
Create a new IP address group address.

```
POST /ip_addr_groups/{ipAddrGroupId}/ip_addrs
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/ip_addr_groups/$IPADDRGROUPID/ip_addrs \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae/ip_addrs/229b39e5-ff1c-4f0f-9d91-9adf6122d423",
  "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "ipAddrGroupId": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "ipAddrGroup": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "addr": "1.2.3.4"
}
```

### IP Address Group Address Delete
Delete the specific IP address group.

```
DELETE /ip_addr_groups/{ipAddrGroupId}/ip_addrs/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/ip_addr_groups/$IPADDRGROUPID/ip_addrs/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae/ip_addrs/229b39e5-ff1c-4f0f-9d91-9adf6122d423",
  "id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "ipAddrGroupId": "a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "ipAddrGroup": "http://example.org:8080/midonet-api/ip_addr_groups/a7d05156-5212-409c-9276-b0a1b4ac5eae",
  "addr": "1.2.3.4"
}
```


## Load Balancer
LoadBalancer is an entity that represents a virtual load balancer device in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310"` |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"b6fac5fc-2d3f-4a81-9eba-feab374cb310"` |
| **routerId** | *uuid* | A unique identifier of the associated router. This property is readonly and not allowed to be updated by users. Please assign load balancers to routers through routers. | `"9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
| **router** | *string* | A URI of the associated router. | `"http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
| **adminStateUp** | *boolean* | The administrative state of the resource. | `true` |
| **vips** | *string* | A GET against this URI gets the list of VIPs associated with the load balancer. | `"http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips"` |
| **pools** | *string* | A GET against this URI gets the list pools associated with the load balancer. | `"http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/pools"` |
### Load Balancer List
Get the list of load blancers.

```
GET /load_balancers
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/load_balancers

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
    "id": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
    "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
    "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
    "adminStateUp": true,
    "vips": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips",
    "pools": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/pools"
  }
]
```

### Load Balancer Info
Get the specific load balancer.

```
GET /load_balancers/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/load_balancers/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "id": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "adminStateUp": true,
  "vips": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips",
  "pools": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/pools"
}
```

### Load Balancer Create
Create a new load balancer.

```
POST /load_balancers
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/load_balancers \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "id": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "adminStateUp": true,
  "vips": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips",
  "pools": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/pools"
}
```

### Load Balancer Update
Update the specific load balancer.

```
PUT /load_balancers/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/load_balancers/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "id": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "adminStateUp": true,
  "vips": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips",
  "pools": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/pools"
}
```

### Load Balancer Delete
Delete the specific load balancer.

```
DELETE /load_balancers/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/load_balancers/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "id": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "adminStateUp": true,
  "vips": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips",
  "pools": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/pools"
}
```


## MacPort
MacPort is an entity that represents an entry of the MAC table in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010"` |
| **vlanId** | *uuid* | ID of the VLAN to which the port with ID portId belongs. This field is used only in responses to GET requests and will be ignored in POST requests. | `"a983cf1a-59ee-45e8-9e3c-1fe30e02f194"` |
| **macAddr** | *string* | A MAC address in the form aa:bb:cc:dd:ee:ff.<br/> **pattern:** <code>^((?:[0-9a-f]{2}:){5}[0-9a-f]{2}&#124;(?:[0-9A-F]{2}:){5}[0-9A-F]{2})$</code> | `"aa:bb:cc:dd:ee:ff"` |
| **portId** | *uuid* | ID of the port to which the packets destined to the macAddr will be emitted. | `"bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"` |
### MacPort List
Get the list of entries of the MAC table.

```
GET /bridges/{bridgeId}/mac_table
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/mac_table

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010",
    "vlanId": "a983cf1a-59ee-45e8-9e3c-1fe30e02f194",
    "macAddr": "aa:bb:cc:dd:ee:ff",
    "portId": "bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"
  }
]
```

### MacPort List (VLAN)
Get the list of entries of the MAC table associated with the specific VLAN.

```
GET /bridges/{bridgeId}/mac_table
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/mac_table

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010",
    "vlanId": "a983cf1a-59ee-45e8-9e3c-1fe30e02f194",
    "macAddr": "aa:bb:cc:dd:ee:ff",
    "portId": "bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"
  }
]
```

### MacPort Info
Get the specific entry in the MAC table.

```
GET /bridges/{bridgeId}/mac_table/{macPortPair}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/mac_table/$MACPORTPAIR

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010",
  "vlanId": "a983cf1a-59ee-45e8-9e3c-1fe30e02f194",
  "macAddr": "aa:bb:cc:dd:ee:ff",
  "portId": "bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"
}
```

### MacPort Info (VLAN)
Get the specific entry in the MAC table associated with the specific VLAN.

```
GET /bridges/{bridgeId}/mac_table/{macPortPair}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/mac_table/$MACPORTPAIR

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010",
  "vlanId": "a983cf1a-59ee-45e8-9e3c-1fe30e02f194",
  "macAddr": "aa:bb:cc:dd:ee:ff",
  "portId": "bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"
}
```

### MacPort Create
Create a new entry in the MAC table.

```
POST /bridges/{bridgeId}/mac_table
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/bridges/$BRIDGEID/mac_table \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010",
  "vlanId": "a983cf1a-59ee-45e8-9e3c-1fe30e02f194",
  "macAddr": "aa:bb:cc:dd:ee:ff",
  "portId": "bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"
}
```

### MacPort Create (VLAN)
Create a new entry in the MAC table.

```
POST /bridges/{bridgeId}/vlans/{vlanId}/mac_table
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/bridges/$BRIDGEID/vlans/$VLANID/mac_table \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010",
  "vlanId": "a983cf1a-59ee-45e8-9e3c-1fe30e02f194",
  "macAddr": "aa:bb:cc:dd:ee:ff",
  "portId": "bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"
}
```

### MacPort Delete
Delete the specific entry in the MAC table.

```
DELETE /bridges/{bridgeId}/mac_table/{macPortPair}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/bridges/$BRIDGEID/mac_table/$MACPORTPAIR \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010",
  "vlanId": "a983cf1a-59ee-45e8-9e3c-1fe30e02f194",
  "macAddr": "aa:bb:cc:dd:ee:ff",
  "portId": "bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"
}
```

### MacPort Delete (VLAN)
Delete the specific entry in the MAC table associated with the specific VLAN.

```
DELETE /bridges/{bridgeId}/vlans/{vlanId}/mac_table/{macPortPair}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/bridges/$BRIDGEID/vlans/$VLANID/mac_table/$MACPORTPAIR \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "/routers/e2f2d94b-a724-4d43-9a86-c67aa72bb010",
  "vlanId": "a983cf1a-59ee-45e8-9e3c-1fe30e02f194",
  "macAddr": "aa:bb:cc:dd:ee:ff",
  "portId": "bf698e2e-dd2f-4a5f-a8e5-d10efcad8320"
}
```


## Neutron
This is the root object of the Neutron resource in MidoNet REST API. From this object, clients can discover the URIs for all the Neutron services provided by MidoNet REST API.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/neutron"` |
| **networks** | *string* | A GET against this URI gets a list of Neutron networks. A POST against this URI creates a new Neutron network. | `"http://example.org:8080/midonet-api/neutron/networks"` |
| **subnets** | *string* | A GET against this URI gets a list of Neutron subnets. A POST against this URI creates a new Neutron subnet. | `"http://example.org:8080/midonet-api/neutron/subnets"` |
| **ports** | *string* | A GET against this URI gets a list of Neutron ports. A POST against this URI creates a new Neutron port. | `"http://example.org:8080/midonet-api/neutron/ports"` |
| **routers** | *string* | A GET against this URI gets a list of Neutron routers. A POST against this URI creates a new Neutron router. | `"http://example.org:8080/midonet-api/neutron/routers"` |
| **floating_ips** | *string* | A GET against this URI gets a list of Neutron floating IP addresses. A POST against this URI creates a new Neutron floating IP address. | `"http://example.org:8080/midonet-api/neutron/floating_ips"` |
| **security_groups** | *string* | A GET against this URI gets a list of Neutron security groups. A POST against this URI creates a new Neutron security group. | `"http://example.org:8080/midonet-api/neutron/security_groups"` |
| **security_groups_rules** | *string* | A GET against this URI gets a list of Neutron security group rules. A POST against this URI creates a new Neutron security group rule. | `"http://example.org:8080/midonet-api/neutron/security_group_rules"` |
| **network_template** | *string* | URI Template that represents the location of a Neutron network. | `"http://example.org:8080/midonet-api/neutron/networks/{id}"` |
| **subnet_template** | *string* | URI Template that represents the location of a Neutron subnet. | `"http://example.org:8080/midonet-api/neutron/subnets/{id}"` |
| **port_template** | *string* | URI Template that represents the location of a Neutron port. | `"http://example.org:8080/midonet-api/neutron/ports/{id}"` |
| **router_template** | *string* | URI Template that represents the location of a Neutron router. | `"http://example.org:8080/midonet-api/neutron/routers/{id}"` |
| **add_router_interface_template** | *string* | A PUT against the URI constructed from this template adds a Neutron router interface. | `"http://example.org:8080/midonet-api/neutron/router/{id}"` |
| **remove_router_interface_template** | *string* | A PUT against the URI constructed from this template removes a Neutron router interface. | `"http://example.org:8080/midonet-api/neutron/router/{id}"` |
| **floating_ip_template** | *string* | URI Template that represents the location of a Neutron floating IP. | `"http://example.org:8080/midonet-api/neutron/floating_ips/{id}"` |
| **security_group_template** | *string* | URI Template that represents the location of a Neutron security group. | `"http://example.org:8080/midonet-api/neutron/security_groups/{id}"` |
| **security_group_rule_template** | *string* | URI Template that represents the location of a Neutron security group rule. | `"http://example.org:8080/midonet-api/neutron/security_group_rules/{id}"` |
### Neutron Info
Get the list of bridges.

```
GET /neutron
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/neutron",
    "networks": "http://example.org:8080/midonet-api/neutron/networks",
    "subnets": "http://example.org:8080/midonet-api/neutron/subnets",
    "ports": "http://example.org:8080/midonet-api/neutron/ports",
    "routers": "http://example.org:8080/midonet-api/neutron/routers",
    "floating_ips": "http://example.org:8080/midonet-api/neutron/floating_ips",
    "security_groups": "http://example.org:8080/midonet-api/neutron/security_groups",
    "security_groups_rules": "http://example.org:8080/midonet-api/neutron/security_group_rules",
    "network_template": "http://example.org:8080/midonet-api/neutron/networks/{id}",
    "subnet_template": "http://example.org:8080/midonet-api/neutron/subnets/{id}",
    "port_template": "http://example.org:8080/midonet-api/neutron/ports/{id}",
    "router_template": "http://example.org:8080/midonet-api/neutron/routers/{id}",
    "add_router_interface_template": "http://example.org:8080/midonet-api/neutron/router/{id}",
    "remove_router_interface_template": "http://example.org:8080/midonet-api/neutron/router/{id}",
    "floating_ip_template": "http://example.org:8080/midonet-api/neutron/floating_ips/{id}",
    "security_group_template": "http://example.org:8080/midonet-api/neutron/security_groups/{id}",
    "security_group_rule_template": "http://example.org:8080/midonet-api/neutron/security_group_rules/{id}"
  }
]
```


## Neutron Floating IP


### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"1405d6c6-a199-44d6-b9af-756dc6f5e3f7"` |
| **tenant_id** | *uuid* | efd28582-bb5d-487c-9286-9a19af4ab0a4 | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **floating_network_id** | *uuid* | ID of the externa network from which the floating IP address was allocated from. | `"7c230d30-e6cb-45d0-80bb-cb494073af50"` |
| **router_id** | *uuid* | ID of the router where the floating IP is NATed. | `"4d8c339e-5fd6-4073-8ede-3ff6034695d8"` |
| **port_id** | *uuid* | Private IP address that the floating IP is associated with in the format x.x.x.x/y, such as 10.0.0.3/24 | `"fe6dddfe-eb36-4dd1-8292-a53e08d04a6f"` |
### Neutron Floating IP List
Get the list of the neutron floating IPs.

```
GET /neutron/floating_ips
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/floating_ips

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
    "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "floating_network_id": "7c230d30-e6cb-45d0-80bb-cb494073af50",
    "router_id": "4d8c339e-5fd6-4073-8ede-3ff6034695d8",
    "port_id": "fe6dddfe-eb36-4dd1-8292-a53e08d04a6f"
  }
]
```

### Neutron Floating IP Info
Get the specific neutron floating IP.

```
GET /neutron/floating_ips/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/floating_ips/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "floating_network_id": "7c230d30-e6cb-45d0-80bb-cb494073af50",
  "router_id": "4d8c339e-5fd6-4073-8ede-3ff6034695d8",
  "port_id": "fe6dddfe-eb36-4dd1-8292-a53e08d04a6f"
}
```

### Neutron Floating IP Create
Create a new neutron floating IP.

```
POST /neutron/floating_ips/
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/neutron/floating_ips/ \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "floating_network_id": "7c230d30-e6cb-45d0-80bb-cb494073af50",
  "router_id": "4d8c339e-5fd6-4073-8ede-3ff6034695d8",
  "port_id": "fe6dddfe-eb36-4dd1-8292-a53e08d04a6f"
}
```

### Neutron Floating IP Update
Update the sepcific neutron floating IP.

```
PUT /neutron/floating_ips/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/floating_ips/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "floating_network_id": "7c230d30-e6cb-45d0-80bb-cb494073af50",
  "router_id": "4d8c339e-5fd6-4073-8ede-3ff6034695d8",
  "port_id": "fe6dddfe-eb36-4dd1-8292-a53e08d04a6f"
}
```

### Neutron Floating IP Delete
Delete the specific neutron floating IP.

```
DELETE /neutron/floating_ips/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/neutron/floating_ips/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "floating_network_id": "7c230d30-e6cb-45d0-80bb-cb494073af50",
  "router_id": "4d8c339e-5fd6-4073-8ede-3ff6034695d8",
  "port_id": "fe6dddfe-eb36-4dd1-8292-a53e08d04a6f"
}
```


## Neutron Network
If a network is created and marked as external, MidoNet API also creates an administratively owned router called Provider Router. Provider router is a MidoNet virtual router that serves as the gateway router for the OpenStack Neutron deployment. This router is responsible for forwarding traffic between the Internet and the OpenStack cloud. It is up to the network operator to configure this router. There can be at most one instance of provider router at any time. To locate this router, search for the router with the name 'MidoNet Provider Router'.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
| **name** | *string* | Name of the resource. | `"neutron_network"` |
| **tenant_id** | *uuid* | ID of the tenant that owns the resource. | `"efd28582-bb5d-487c-9286-9a19af4ab0a4"` |
| **admin_state_up** | *boolean* | The administrative state of the resource. Default is true (up). | `true` |
| **external** | *boolean* | Indicates whether this network is external - administraively owned. Default is false. |  |
| **shared** | *boolean* | Indicates whether this resource is shared among tenants. |  |
| **status** | *string* |  | `""` |
### Neutron Network List
Get the list of the neutron network.

```
GET /neutron/networks
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/networks

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
    "name": "neutron_network",
    "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
    "admin_state_up": true,
    "external": null,
    "shared": null,
    "status": ""
  }
]
```

### Neutron Network Info
Get the specific neutron network.

```
GET /neutron/networks/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/networks/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "name": "neutron_network",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "admin_state_up": true,
  "external": null,
  "shared": null,
  "status": ""
}
```

### Neutron Network Create
Create a new neutron network.

```
POST /neutron/networks
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/neutron/networks \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "name": "neutron_network",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "admin_state_up": true,
  "external": null,
  "shared": null,
  "status": ""
}
```

### Neutron Network Update
Update the sepcific neutron network.

```
PUT /neutron/networks/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/networks/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "name": "neutron_network",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "admin_state_up": true,
  "external": null,
  "shared": null,
  "status": ""
}
```

### Neutron Network Delete
Delete the specific neutron network.

```
DELETE /neutron/networks/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/neutron/networks/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "name": "neutron_network",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "admin_state_up": true,
  "external": null,
  "shared": null,
  "status": ""
}
```


## Neutron Port


### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"/routers/3db09bea-992d-476c-a06c-f086058da49b"` |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"1405d6c6-a199-44d6-b9af-756dc6f5e3f7"` |
| **name** | *uuid* | Name of the resource. | `"neutron_port"` |
| **tenant_id** | *uuid* | efd28582-bb5d-487c-9286-9a19af4ab0a4 | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **admin_state_up** | *boolean* | The administrative state of the resource. Default is true (up). | `true` |
| **network_id** | *uuid* | ID of the network this port belongs to. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **mac_address** | *string* | MAC address of the instance attached to this port.<br/> **pattern:** <code>^((?:[0-9a-f]{2}:){5}[0-9a-f]{2}&#124;(?:[0-9A-F]{2}:){5}[0-9A-F]{2})$</code> | `"aa:bb:cc:dd:ee:ff"` |
| **fixed_ips** | *array* | List of IP addresses assigned to this port and the subnet that the address was allocated from. | `[{"ip_address":"10.0.0.2","subnet_id":"2b061d5e-4c0d-448c-be6c-4495d73ba5ad"}]` |
| **device_id** | *uuid* | ID of the device that owns the port. | `"77eb1bf3-e110-4f86-b0b6-bc5ff0fa5e84"` |
| **device_owner** | *string* | Owner of the device that owns the port. If none of the possible values is set, then the port is considered to be VIF port where a VM attaches to.<br/> **one of:**`"network:dhcp"` or `"network:floatingip"` or `"network:router_gateway"` or `"network:router_interface"` | `"network:dhcp"` |
| **status** | *string* | Status of this resource. This field is currently unused. | `""` |
### Neutron Port List
Get the list of the neutron ports.

```
GET /neutron/ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "/routers/3db09bea-992d-476c-a06c-f086058da49b",
    "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
    "name": "neutron_port",
    "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "admin_state_up": true,
    "network_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "mac_address": "aa:bb:cc:dd:ee:ff",
    "fixed_ips": [
      {
        "ip_address": "10.0.0.2",
        "subnet_id": "2b061d5e-4c0d-448c-be6c-4495d73ba5ad"
      }
    ],
    "device_id": "77eb1bf3-e110-4f86-b0b6-bc5ff0fa5e84",
    "device_owner": "network:dhcp",
    "status": ""
  }
]
```

### Neutron Port Info
Get the specific neutron port.

```
GET /neutron/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/ports/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "/routers/3db09bea-992d-476c-a06c-f086058da49b",
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_port",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "admin_state_up": true,
  "network_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "mac_address": "aa:bb:cc:dd:ee:ff",
  "fixed_ips": [
    {
      "ip_address": "10.0.0.2",
      "subnet_id": "2b061d5e-4c0d-448c-be6c-4495d73ba5ad"
    }
  ],
  "device_id": "77eb1bf3-e110-4f86-b0b6-bc5ff0fa5e84",
  "device_owner": "network:dhcp",
  "status": ""
}
```

### Neutron Port Create
Create a new neutron port.

```
POST /neutron/ports
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/neutron/ports \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "/routers/3db09bea-992d-476c-a06c-f086058da49b",
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_port",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "admin_state_up": true,
  "network_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "mac_address": "aa:bb:cc:dd:ee:ff",
  "fixed_ips": [
    {
      "ip_address": "10.0.0.2",
      "subnet_id": "2b061d5e-4c0d-448c-be6c-4495d73ba5ad"
    }
  ],
  "device_id": "77eb1bf3-e110-4f86-b0b6-bc5ff0fa5e84",
  "device_owner": "network:dhcp",
  "status": ""
}
```

### Neutron Port Update
Update the sepcific neutron port.

```
PUT /neutron/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/ports/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "/routers/3db09bea-992d-476c-a06c-f086058da49b",
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_port",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "admin_state_up": true,
  "network_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "mac_address": "aa:bb:cc:dd:ee:ff",
  "fixed_ips": [
    {
      "ip_address": "10.0.0.2",
      "subnet_id": "2b061d5e-4c0d-448c-be6c-4495d73ba5ad"
    }
  ],
  "device_id": "77eb1bf3-e110-4f86-b0b6-bc5ff0fa5e84",
  "device_owner": "network:dhcp",
  "status": ""
}
```

### Neutron Port Delete
Delete the specific neutron port.

```
DELETE /neutron/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/neutron/ports/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "/routers/3db09bea-992d-476c-a06c-f086058da49b",
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_port",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "admin_state_up": true,
  "network_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "mac_address": "aa:bb:cc:dd:ee:ff",
  "fixed_ips": [
    {
      "ip_address": "10.0.0.2",
      "subnet_id": "2b061d5e-4c0d-448c-be6c-4495d73ba5ad"
    }
  ],
  "device_id": "77eb1bf3-e110-4f86-b0b6-bc5ff0fa5e84",
  "device_owner": "network:dhcp",
  "status": ""
}
```


## Neutron Router


### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"1405d6c6-a199-44d6-b9af-756dc6f5e3f7"` |
| **name** | *string* | Name of the resource. | `"neutron_port"` |
| **tenant_id** | *uuid* | ID of the tenant that owns the resource. | `"efd28582-bb5d-487c-9286-9a19af4ab0a4"` |
| **admin_state_up** | *boolean* | The administrative state of the resource. Default is true (up). | `true` |
| **gw_port_id** | *uuid* | ID of the gateway port on the external network. | `"963e19da-3e66-4594-8576-dfcb3885b187"` |
| **external_gateway** | *object* | Information about the gateway, which consists of the following fields:   * network_id: ID of the external network. This field is required.   * enable_snat: Enabling SNAT allows VMs to reach the Internet. This                  field is optional and is defaulted to True. |  |
| **status** | *string* | Status of this resource. This field is currently unused. | `""` |
### Neutron Router List
Get the list of the neutron router.

```
GET /neutron/routers
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/routers

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
    "name": "neutron_port",
    "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
    "admin_state_up": true,
    "gw_port_id": "963e19da-3e66-4594-8576-dfcb3885b187",
    "external_gateway": null,
    "status": ""
  }
]
```

### Neutron Router Info
Get the specific neutron router.

```
GET /neutron/routers/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/routers/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_port",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "admin_state_up": true,
  "gw_port_id": "963e19da-3e66-4594-8576-dfcb3885b187",
  "external_gateway": null,
  "status": ""
}
```

### Neutron Router Create
Create a new neutron router.

```
POST /neutron/routers
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/neutron/routers \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_port",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "admin_state_up": true,
  "gw_port_id": "963e19da-3e66-4594-8576-dfcb3885b187",
  "external_gateway": null,
  "status": ""
}
```

### Neutron Router Update
Update the sepcific neutron router.

```
PUT /neutron/routers/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/routers/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_port",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "admin_state_up": true,
  "gw_port_id": "963e19da-3e66-4594-8576-dfcb3885b187",
  "external_gateway": null,
  "status": ""
}
```

### Neutron Router Delete
Delete the specific neutron router.

```
DELETE /neutron/routers/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/neutron/routers/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_port",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "admin_state_up": true,
  "gw_port_id": "963e19da-3e66-4594-8576-dfcb3885b187",
  "external_gateway": null,
  "status": ""
}
```


## Neutron Router Interface


### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **id** | *uuid* | ID of the router to which an interface is added to or removed from. | `"1405d6c6-a199-44d6-b9af-756dc6f5e3f7"` |
| **tenant_id** | *uuid* | ID of the tenant that owns the resource. | `"efd28582-bb5d-487c-9286-9a19af4ab0a4"` |
| **port_id** | *uuid* | ID of the interface port. | `"5da4a6a4-6d5d-43e4-8f8c-d2a902284d84"` |
| **subnet_id** | *uuid* | ID of the subnet to which the interface port is allocated in. | `"5da4a6a4-6d5d-43e4-8f8c-d2a902284d84"` |
### Neutron Router Interface Add router interface
Update the sepcific neutron router.

```
PUT /neutron/routers/{id}/add_router_interface
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/routers/$ID/add_router_interface \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "port_id": "5da4a6a4-6d5d-43e4-8f8c-d2a902284d84",
  "subnet_id": "5da4a6a4-6d5d-43e4-8f8c-d2a902284d84"
}
```

### Neutron Router Interface Remove router interface
Update the sepcific neutron router.

```
PUT /neutron/routers/{id}/remove_router_interface
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/routers/$ID/remove_router_interface \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "port_id": "5da4a6a4-6d5d-43e4-8f8c-d2a902284d84",
  "subnet_id": "5da4a6a4-6d5d-43e4-8f8c-d2a902284d84"
}
```


## Neutron Security Group


### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"1405d6c6-a199-44d6-b9af-756dc6f5e3f7"` |
| **name** | *string* | Name of the resource. | `"neutron_network"` |
| **tenant_id** | *uuid* | ID of the tenant that owns the resource. | `"efd28582-bb5d-487c-9286-9a19af4ab0a4"` |
| **description** | *string* | Description of the resource. | `"neutron_network"` |
| **security_group_rules** | *array* | List of rules belonging to this security group. | `[{"direction":"ingress","tenant_id":"foo","ethertype":"ipv4"}]` |
### Neutron Security Group List
Get the list of the neutron security groups.

```
GET /neutron/security_groups
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/security_groups

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
    "name": "neutron_network",
    "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
    "description": "neutron_network",
    "security_group_rules": [
      {
        "direction": "ingress",
        "tenant_id": "foo",
        "ethertype": "ipv4"
      }
    ]
  }
]
```

### Neutron Security Group Info
Get the specific neutron security groups.

```
GET /neutron/security_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/security_groups/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_network",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "description": "neutron_network",
  "security_group_rules": [
    {
      "direction": "ingress",
      "tenant_id": "foo",
      "ethertype": "ipv4"
    }
  ]
}
```

### Neutron Security Group Create
Create a new neutron security group.

```
POST /neutron/security_groups/
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/neutron/security_groups/ \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_network",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "description": "neutron_network",
  "security_group_rules": [
    {
      "direction": "ingress",
      "tenant_id": "foo",
      "ethertype": "ipv4"
    }
  ]
}
```

### Neutron Security Group Update
Update the sepcific neutron security group.

```
PUT /neutron/security_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/security_groups/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_network",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "description": "neutron_network",
  "security_group_rules": [
    {
      "direction": "ingress",
      "tenant_id": "foo",
      "ethertype": "ipv4"
    }
  ]
}
```

### Neutron Security Group Delete
Delete the specific neutron security group.

```
DELETE /neutron/security_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/neutron/security_groups/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_network",
  "tenant_id": "efd28582-bb5d-487c-9286-9a19af4ab0a4",
  "description": "neutron_network",
  "security_group_rules": [
    {
      "direction": "ingress",
      "tenant_id": "foo",
      "ethertype": "ipv4"
    }
  ]
}
```


## Neutron Security Group Rule


### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated.  If you want to match on a particular port number, specify that number for both port_range_min and port_range_max. | `"1405d6c6-a199-44d6-b9af-756dc6f5e3f7"` |
| **name** | *string* | Name of the resource. | `"neutron_subnet"` |
| **tenant_id** | *uuid* | efd28582-bb5d-487c-9286-9a19af4ab0a4 | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **security_group_id** | *uuid* | ID of the security group that the rule belongs to. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **remote_group_id** | *uuid* | ID of the security group to match against. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **direction** | *string* | Direction of traffic to apply the rule. Egress is traffic leaving the VM. Ingress is traffic destined to the VM.<br/> **one of:**`"eggress"` or `"ingress"` |  |
| **protocol** | *string* | Protocol to match against.<br/> **one of:**`"tcp"` or `"udp"` or `"icmp"` or `"icmpv6"` | `"tcp"` |
| **port_range_min** | *integer* | Start protocol port number to match on. | `80` |
| **port_range_max** | *integer* | End protocol port number to match on. | `8080` |
| **ethertype** | *string* |   Ethertype to match on. Possible values are:      * arp     * ipv4     * ipv6 (not yet supported) | `"arp"` |
| **remote_ip_prefix** | *string* | IP address in the CIDR format (x.x.x.x/y) to match on. |  |
### Neutron Security Group Rule List
Get the list of the neutron security group rules.

```
GET /neutron/security_group_rules
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/security_group_rules

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
    "name": "neutron_subnet",
    "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "security_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "remote_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "direction": null,
    "protocol": "tcp",
    "port_range_min": 80,
    "port_range_max": 8080,
    "ethertype": "arp",
    "remote_ip_prefix": null
  }
]
```

### Neutron Security Group Rule Info
Get the specific neutron security group rule.

```
GET /neutron/security_group_rules/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/security_group_rules/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_subnet",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "security_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "remote_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "direction": null,
  "protocol": "tcp",
  "port_range_min": 80,
  "port_range_max": 8080,
  "ethertype": "arp",
  "remote_ip_prefix": null
}
```

### Neutron Security Group Rule Create
Create a new neutron security group rule.

```
POST /neutron/security_group_rules/
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/neutron/security_group_rules/ \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_subnet",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "security_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "remote_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "direction": null,
  "protocol": "tcp",
  "port_range_min": 80,
  "port_range_max": 8080,
  "ethertype": "arp",
  "remote_ip_prefix": null
}
```

### Neutron Security Group Rule Update
Update the sepcific neutron security group rule.

```
PUT /neutron/security_group_rules/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/security_group_rules/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_subnet",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "security_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "remote_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "direction": null,
  "protocol": "tcp",
  "port_range_min": 80,
  "port_range_max": 8080,
  "ethertype": "arp",
  "remote_ip_prefix": null
}
```

### Neutron Security Group Rule Delete
Delete the specific neutron security group rule.

```
DELETE /neutron/security_group_rules/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/neutron/security_group_rules/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_subnet",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "security_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "remote_group_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "direction": null,
  "protocol": "tcp",
  "port_range_min": 80,
  "port_range_max": 8080,
  "ethertype": "arp",
  "remote_ip_prefix": null
}
```


## Neutron Subnet


### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"1405d6c6-a199-44d6-b9af-756dc6f5e3f7"` |
| **name** | *string* | Name of the resource. | `"neutron_subnet"` |
| **tenant_id** | *uuid* | efd28582-bb5d-487c-9286-9a19af4ab0a4 | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **admin_state_up** | *boolean* | The administrative state of the resource. Default is true (up). | `true` |
| **ip_version** | *integer* | Version of IP (4 or 6) Currently only 4 is supported. | `4` |
| **share** | *boolean* | Indicates whether this resource is shared among tenants. | `true` |
| **cidr** | *string* | CIDR of the subnet Format should be x.x.x.x/y, such as 10.0.0.0/24.<br/> **pattern:** <code>^((25[0-5]&#124;2[0-4][0-9]&#124;1?[0-9]?[0-9]).){3}(25[0-5]&#124;2[0-4][0-9]&#124;1?[0-9]?[0-9])/(3[0-2]&#124;((1&#124;2)?[0-9]))$</code> | `"10.0.0.0/24"` |
| **gateway_ip** | *ipv4* | Gateway IP address of this subnet. | `"10.0.0.1"` |
| **enable_dhcp** | *boolean* | Enable/disable DHCP on this subnet. Default is true (enabled). | `true` |
| **allocation_pools** | *array* | List of IP range pairs to specify the range of IPs used to allocate to ports. | `[{"start":"192.168.100.2","end":"192.168.100.254"}]` |
| **host_routes** | *array* | List of routes to specify option 121 routes to include in DHCP. | `[{"destination":"10.0.0.2/24","nexthop":"10.0.1.1"}]` |
| **dns_nameserver** | *array* |  | `["8.8.8.8","8.8.4.4"]` |
### Neutron Subnet List
Get the list of the neutron subnets.

```
GET /neutron/subnets
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/subnets

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
    "name": "neutron_subnet",
    "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "admin_state_up": true,
    "ip_version": 4,
    "share": true,
    "cidr": "10.0.0.0/24",
    "gateway_ip": "10.0.0.1",
    "enable_dhcp": true,
    "allocation_pools": [
      {
        "start": "192.168.100.2",
        "end": "192.168.100.254"
      }
    ],
    "host_routes": [
      {
        "destination": "10.0.0.2/24",
        "nexthop": "10.0.1.1"
      }
    ],
    "dns_nameserver": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  }
]
```

### Neutron Subnet Info
Get the specific neutron subnet.

```
GET /neutron/subnets/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/neutron/subnets/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_subnet",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "admin_state_up": true,
  "ip_version": 4,
  "share": true,
  "cidr": "10.0.0.0/24",
  "gateway_ip": "10.0.0.1",
  "enable_dhcp": true,
  "allocation_pools": [
    {
      "start": "192.168.100.2",
      "end": "192.168.100.254"
    }
  ],
  "host_routes": [
    {
      "destination": "10.0.0.2/24",
      "nexthop": "10.0.1.1"
    }
  ],
  "dns_nameserver": [
    "8.8.8.8",
    "8.8.4.4"
  ]
}
```

### Neutron Subnet Create
Create a new neutron subnet.

```
POST /neutron/subnets
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/neutron/subnets \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_subnet",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "admin_state_up": true,
  "ip_version": 4,
  "share": true,
  "cidr": "10.0.0.0/24",
  "gateway_ip": "10.0.0.1",
  "enable_dhcp": true,
  "allocation_pools": [
    {
      "start": "192.168.100.2",
      "end": "192.168.100.254"
    }
  ],
  "host_routes": [
    {
      "destination": "10.0.0.2/24",
      "nexthop": "10.0.1.1"
    }
  ],
  "dns_nameserver": [
    "8.8.8.8",
    "8.8.4.4"
  ]
}
```

### Neutron Subnet Update
Update the sepcific neutron subnet.

```
PUT /neutron/subnets/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/neutron/subnets/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_subnet",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "admin_state_up": true,
  "ip_version": 4,
  "share": true,
  "cidr": "10.0.0.0/24",
  "gateway_ip": "10.0.0.1",
  "enable_dhcp": true,
  "allocation_pools": [
    {
      "start": "192.168.100.2",
      "end": "192.168.100.254"
    }
  ],
  "host_routes": [
    {
      "destination": "10.0.0.2/24",
      "nexthop": "10.0.1.1"
    }
  ],
  "dns_nameserver": [
    "8.8.8.8",
    "8.8.4.4"
  ]
}
```

### Neutron Subnet Delete
Delete the specific neutron subnet.

```
DELETE /neutron/subnets/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/neutron/subnets/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": "1405d6c6-a199-44d6-b9af-756dc6f5e3f7",
  "name": "neutron_subnet",
  "tenant_id": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "admin_state_up": true,
  "ip_version": 4,
  "share": true,
  "cidr": "10.0.0.0/24",
  "gateway_ip": "10.0.0.1",
  "enable_dhcp": true,
  "allocation_pools": [
    {
      "start": "192.168.100.2",
      "end": "192.168.100.254"
    }
  ],
  "host_routes": [
    {
      "destination": "10.0.0.2/24",
      "nexthop": "10.0.1.1"
    }
  ],
  "dns_nameserver": [
    "8.8.8.8",
    "8.8.4.4"
  ]
}
```


## Pool
A Pool is an entity that represents a group of backend load balancer addresses in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6"` |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6"` |
| **loadBalancerId** | *uuid* | Load balancer object to which it is associated with. | `"59e72865-57d2-4eda-99e7-98bcf878bc52"` |
| **loadBalancer** | *string* | A GET against this URI gets the load balancer object. | `"http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52"` |
| **protocol** | *string* | The read-only value represents the protocol used in the load balancing. Only "TCP" is supported.<br/> **one of:**`"TCP"` | `"TCP"` |
| **lbMethod** | *string* | Load balancing algorithm. Only "ROUND_ROBIN" is supported.<br/> **one of:**`"ROUND_ROBIN"` | `"ROUND_ROBIN"` |
| **healthMonitorId** | *uuid* | ID of the health monitor object to assign to the pool. | `"068a9c0f-5eda-467f-a00e-49177c186bbd"` |
| **healthMonitor** | *string* | A GET against this URI gets the health monitor object. | `"http://example.org:8080/midonet-api/health_monitors/e1244270-928d-4cf2-b23b-40fd5fc25755"` |
| **poolMember** | *string* | A GET against this URI gets the list of URLs for the member objects. | `"http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members"` |
| **adminStateUp** | *boolean* | The administrative state of the resource. | `true` |
| **vips** | *string* | A GET against this URI gets the list of VIPs associated with the pool. | `"http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/vips"` |
### Pool List
Get the list of pools on a load balancer.

```
GET /load_balancers/{loadBalancerId}/pools
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
    "id": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
    "loadBalancerId": "59e72865-57d2-4eda-99e7-98bcf878bc52",
    "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52",
    "protocol": "TCP",
    "lbMethod": "ROUND_ROBIN",
    "healthMonitorId": "068a9c0f-5eda-467f-a00e-49177c186bbd",
    "healthMonitor": "http://example.org:8080/midonet-api/health_monitors/e1244270-928d-4cf2-b23b-40fd5fc25755",
    "poolMember": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members",
    "adminStateUp": true,
    "vips": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/vips"
  }
]
```

### Pool Info
Get the specific pool on a load blancer.

```
GET /load_balancers/{loadBalancerId}/pools/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "id": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "loadBalancerId": "59e72865-57d2-4eda-99e7-98bcf878bc52",
  "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52",
  "protocol": "TCP",
  "lbMethod": "ROUND_ROBIN",
  "healthMonitorId": "068a9c0f-5eda-467f-a00e-49177c186bbd",
  "healthMonitor": "http://example.org:8080/midonet-api/health_monitors/e1244270-928d-4cf2-b23b-40fd5fc25755",
  "poolMember": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members",
  "adminStateUp": true,
  "vips": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/vips"
}
```

### Pool Create
Create a new pool on a load balancer.

```
POST /load_balancers/{loadBalancerId}/pools
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "id": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "loadBalancerId": "59e72865-57d2-4eda-99e7-98bcf878bc52",
  "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52",
  "protocol": "TCP",
  "lbMethod": "ROUND_ROBIN",
  "healthMonitorId": "068a9c0f-5eda-467f-a00e-49177c186bbd",
  "healthMonitor": "http://example.org:8080/midonet-api/health_monitors/e1244270-928d-4cf2-b23b-40fd5fc25755",
  "poolMember": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members",
  "adminStateUp": true,
  "vips": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/vips"
}
```

### Pool Update
Update the specific pool on a load balancer.

```
PUT /load_balancers/{loadBalancerId}/pools/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "id": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "loadBalancerId": "59e72865-57d2-4eda-99e7-98bcf878bc52",
  "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52",
  "protocol": "TCP",
  "lbMethod": "ROUND_ROBIN",
  "healthMonitorId": "068a9c0f-5eda-467f-a00e-49177c186bbd",
  "healthMonitor": "http://example.org:8080/midonet-api/health_monitors/e1244270-928d-4cf2-b23b-40fd5fc25755",
  "poolMember": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members",
  "adminStateUp": true,
  "vips": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/vips"
}
```

### Pool Delete
Delete the specific pool on a load balancer.

```
DELETE /load_balancers/{loadBalancerId}/pools/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "id": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "loadBalancerId": "59e72865-57d2-4eda-99e7-98bcf878bc52",
  "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52",
  "protocol": "TCP",
  "lbMethod": "ROUND_ROBIN",
  "healthMonitorId": "068a9c0f-5eda-467f-a00e-49177c186bbd",
  "healthMonitor": "http://example.org:8080/midonet-api/health_monitors/e1244270-928d-4cf2-b23b-40fd5fc25755",
  "poolMember": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members",
  "adminStateUp": true,
  "vips": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/vips"
}
```


## PoolMembe
A PoolMember is an entity that represents a backend load balancer address in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members/109bc661-48c1-4a07-b634-888a7c0594c3"` |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"109bc661-48c1-4a07-b634-888a7c0594c3"` |
| **poolId** | *uuid* | ID of the pool. | `"31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6"` |
| **pool** | *string* | A GET against this URI retrieves the Pool. | `"http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6"` |
| **address** | *ipv4* | IP address of the member. | `"1.2.3.4"` |
| **protocolPort** | *integer* | Protocol port of the member.<br/> **Range:** `0 <= value <= 65535` | `80` |
| **weight** | *integer* | Weight used for random algorithm. Defaults to 1.<br/> **default:** `1`<br/> **Range:** `1 <= value` | `42` |
| **adminStateUp** | *boolean* | Administrative state of the object. | `true` |
| **status** | *string* | The status of the object. Values are:   * UP   * DOWN<br/> **one of:**`"UP"` or `"DOWN"` | `"UP"` |
### PoolMembe List
Get the list of pool members on a pool.

```
GET /load_balancers/{loadBalancerId}/pools/{poolId}/pool_members
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools/$POOLID/pool_members

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members/109bc661-48c1-4a07-b634-888a7c0594c3",
    "id": "109bc661-48c1-4a07-b634-888a7c0594c3",
    "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
    "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
    "address": "1.2.3.4",
    "protocolPort": 80,
    "weight": 42,
    "adminStateUp": true,
    "status": "UP"
  }
]
```

### PoolMembe Info
Get the specific pool on a load blancer.

```
GET /load_balancers/{loadBalancerId}/pools/{poolId}/pool_members/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools/$POOLID/pool_members/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members/109bc661-48c1-4a07-b634-888a7c0594c3",
  "id": "109bc661-48c1-4a07-b634-888a7c0594c3",
  "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "address": "1.2.3.4",
  "protocolPort": 80,
  "weight": 42,
  "adminStateUp": true,
  "status": "UP"
}
```

### PoolMembe Create
Create a new pool on a load balancer.

```
POST /load_balancers/{loadBalancerId}/pools/{poolId}/pool_members
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools/$POOLID/pool_members \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members/109bc661-48c1-4a07-b634-888a7c0594c3",
  "id": "109bc661-48c1-4a07-b634-888a7c0594c3",
  "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "address": "1.2.3.4",
  "protocolPort": 80,
  "weight": 42,
  "adminStateUp": true,
  "status": "UP"
}
```

### PoolMembe Update
Update the specific pool on a load balancer.

```
PUT /load_balancers/{loadBalancerId}/pools/{poolId}/pool_members/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools/$POOLID/pool_members/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members/109bc661-48c1-4a07-b634-888a7c0594c3",
  "id": "109bc661-48c1-4a07-b634-888a7c0594c3",
  "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "address": "1.2.3.4",
  "protocolPort": 80,
  "weight": 42,
  "adminStateUp": true,
  "status": "UP"
}
```

### PoolMembe Delete
Delete the specific pool on a load balancer.

```
DELETE /load_balancers/{loadBalancerId}/pools/{poolId}/pool_members/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/load_balancers/$LOADBALANCERID/pools/$POOLID/pool_members/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6/pool_members/109bc661-48c1-4a07-b634-888a7c0594c3",
  "id": "109bc661-48c1-4a07-b634-888a7c0594c3",
  "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "address": "1.2.3.4",
  "protocolPort": 80,
  "weight": 42,
  "adminStateUp": true,
  "status": "UP"
}
```


## Port
Port is an entity that represents a port on a virtual device (bridge or router) in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
| **id** | *uuid* | A unique identifier of the resource. | `"afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
| **adminStateUp** | *boolean* | The administrative state of the port. If false (down), the port stops forwarding packets. If it is a router port, it adittionally replies with a  'Communication administratively prohibited' ICMP Default is true (up). | `true` |
| **deviceId** | *uuid* | ID of the device (bridge or router) that this port belongs to. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **type** | *object* | Type of device port. It must be one of:    * Router   * Bridge  A new router or bridge port is unplugged. Depending on what it is later attached to, it is referred to as an exterior or interior port.  An exterior router port is a virtual port that plugs into the VIF of an entity, such as a VM. It can also be a virtual port connected to a host physical port, directly or after implementing tunnel encapsulation. Access to exterior ports is managed by OpenVSwitch (OpenFlow switch). Exterior bridge port is the same as exterior router port but it is a port on a virtual bridge. Upon being bound to an interface, the port becomes exterior and will have the hostId, host, and interfaceName fields be non-null. The peer and peerId fields will be null.  An interior router port is a virtual port that only exists in the MidoNet virtual router network abstraction. It refers to a logical connection to another virtual networking device such as another router. An interior bridge port is the equivalent on a virtual bridge. Upon being linked to a peer, a port will become interior and will have the peer and peerId fields be non-null. The hostId, host, and interfaceName fields will be null.  There is a third type of port, Vxlan, which is created automatically when binding a VTEP to a Neutron network. The only operations supported on a port of this type are GET and DELETE. Deleting a VXLAN port will delete all associated VTEP bindings. | `"Router"` |
| **peerId** | *uuid* | ID of the peer port that this port is linked to. This will be set when linking a port to another peer (becoming an interior port). | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **peer** | *string* | A GET against this URI retrieves the peer port resource. Requires a port to be linked to another port. | `"/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460"` |
| **networkAddress** | *ipv4* | IP address of the network attached to this port. For example, 192.168.10.32. | `"192.168.10.0"` |
| **networkLength** | *integer* | Prefix length of the network attached to this port (number of fixed network bits).<br/> **Range:** `0 <= value <= 32` | `24` |
| **portAddress** | *ipv4* | IP address assigned to the port. | `"192.168.10.32"` |
| **portMac** | *string* | Port MAC address.<br/> **pattern:** <code>^((?:[0-9a-f]{2}:){5}[0-9a-f]{2}&#124;(?:[0-9A-F]{2}:){5}[0-9A-F]{2})$</code> | `"aa:bb:cc:dd:ee:ff"` |
| **vifId** | *uuid* | ID of the VIF plugged into the port. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **hostId** | *uuid* | ID of the port's host. This will be set when binding a port to a host (becoming an exterior port). | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **host** | *uuid* | The port host's URI. Requires a port to be bound to a host | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **interfaceName** | *string* | Interface name of a bound port. This will be set when binding a port to a host (becoming an exterior port). | `"mido0"` |
| **bgps** | *string* | A GET against this URI retrieves BGP configurations for this port. | `"http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50"` |
| **link** | *string* | Location of the port link resource. A POST against this URI links two interior ports. In the body of the request, 'peerId' must be specified to indicate the peer interior port ID. A DELETE against this URI removes the link. | `"http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link"` |
| **inboundFilterId** | *uuid* | ID of the filter chain to be applied for incoming packets. | `"f56060f7-a2b9-4da5-ae91-a07a6311d660"` |
| **inboundFilter** | *string* | A GET against this URI retrieves the inbound filter chain. | `"http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660"` |
| **outboundFilterId** | *uuid* | ID of the filter chain to be applied for outgoing packets. | `"54033d05-13e5-47a4-9da8-69c49138dd4b"` |
| **outboundFilter** | *string* | A GET against this URI retrieves the outbound filter chain. | `"http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b"` |
| **portGroups** | *string* | A GET against this URI retrieves the port groups that this port is a member of. | `"http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9"` |
| **hostInterfacePort** | *string* | A GET against this URI retrieves the interface-binding information of this port. | `"http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort"` |
| **vlanId** | *integer* | The VLAN ID assigned to this port. On a given bridge, each VLAN ID can be present at most in one interior port. | `1234` |
### Port List
Get the list of ports.

```
GET /ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "adminStateUp": true,
    "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "type": "Router",
    "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
    "networkAddress": "192.168.10.0",
    "networkLength": 24,
    "portAddress": "192.168.10.32",
    "portMac": "aa:bb:cc:dd:ee:ff",
    "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "interfaceName": "mido0",
    "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
    "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
    "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
    "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
    "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
    "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
    "vlanId": 1234
  }
]
```

### Port Info
Get the specific port.

```
GET /ports/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ports/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "adminStateUp": true,
  "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "type": "Router",
  "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
  "networkAddress": "192.168.10.0",
  "networkLength": 24,
  "portAddress": "192.168.10.32",
  "portMac": "aa:bb:cc:dd:ee:ff",
  "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "interfaceName": "mido0",
  "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
  "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
  "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
  "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
  "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
  "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
  "vlanId": 1234
}
```

### Port List (Router)
Get the list of ports on a router.

```
GET /routers/{routerId}/ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/routers/$ROUTERID/ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "adminStateUp": true,
    "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "type": "Router",
    "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
    "networkAddress": "192.168.10.0",
    "networkLength": 24,
    "portAddress": "192.168.10.32",
    "portMac": "aa:bb:cc:dd:ee:ff",
    "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "interfaceName": "mido0",
    "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
    "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
    "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
    "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
    "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
    "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
    "vlanId": 1234
  }
]
```

### Port List Peers (Router)
Get the list of peer ports on a router.

```
GET /routers/{routerId}/peer_ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/routers/$ROUTERID/peer_ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "adminStateUp": true,
    "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "type": "Router",
    "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
    "networkAddress": "192.168.10.0",
    "networkLength": 24,
    "portAddress": "192.168.10.32",
    "portMac": "aa:bb:cc:dd:ee:ff",
    "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "interfaceName": "mido0",
    "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
    "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
    "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
    "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
    "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
    "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
    "vlanId": 1234
  }
]
```

### Port List (Bridge)
Get the list of ports on a bridge.

```
GET /bridges/{bridgeId}/ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "adminStateUp": true,
    "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "type": "Router",
    "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
    "networkAddress": "192.168.10.0",
    "networkLength": 24,
    "portAddress": "192.168.10.32",
    "portMac": "aa:bb:cc:dd:ee:ff",
    "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "interfaceName": "mido0",
    "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
    "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
    "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
    "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
    "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
    "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
    "vlanId": 1234
  }
]
```

### Port List Peers (Bridge)
Get the list of peer ports on a bridge.

```
GET /bridges/{bridgeId}/peer_ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/bridges/$BRIDGEID/peer_ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "adminStateUp": true,
    "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "type": "Router",
    "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
    "networkAddress": "192.168.10.0",
    "networkLength": 24,
    "portAddress": "192.168.10.32",
    "portMac": "aa:bb:cc:dd:ee:ff",
    "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "interfaceName": "mido0",
    "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
    "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
    "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
    "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
    "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
    "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
    "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
    "vlanId": 1234
  }
]
```

### Port Create (Router)
Create a new port on a router.

```
POST /routers/{routerId}/ports
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/routers/$ROUTERID/ports \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "adminStateUp": true,
  "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "type": "Router",
  "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
  "networkAddress": "192.168.10.0",
  "networkLength": 24,
  "portAddress": "192.168.10.32",
  "portMac": "aa:bb:cc:dd:ee:ff",
  "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "interfaceName": "mido0",
  "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
  "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
  "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
  "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
  "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
  "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
  "vlanId": 1234
}
```

### Port Create (Bridge)
Create a new port on a bridge.

```
POST /bridges/{bridgeId}/ports
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/bridges/$BRIDGEID/ports \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "adminStateUp": true,
  "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "type": "Router",
  "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
  "networkAddress": "192.168.10.0",
  "networkLength": 24,
  "portAddress": "192.168.10.32",
  "portMac": "aa:bb:cc:dd:ee:ff",
  "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "interfaceName": "mido0",
  "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
  "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
  "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
  "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
  "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
  "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
  "vlanId": 1234
}
```

### Port Update
Update the specific port.

```
PUT /ports/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/ports/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "adminStateUp": true,
  "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "type": "Router",
  "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
  "networkAddress": "192.168.10.0",
  "networkLength": 24,
  "portAddress": "192.168.10.32",
  "portMac": "aa:bb:cc:dd:ee:ff",
  "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "interfaceName": "mido0",
  "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
  "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
  "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
  "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
  "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
  "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
  "vlanId": 1234
}
```

### Port Delete
Delete the specific port.

```
DELETE /ports/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/ports/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "id": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "adminStateUp": true,
  "deviceId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "type": "Router",
  "peerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "peer": "/routers/1ae9694d-f5a7-4b5d-832d-d642fb386460",
  "networkAddress": "192.168.10.0",
  "networkLength": 24,
  "portAddress": "192.168.10.32",
  "portMac": "aa:bb:cc:dd:ee:ff",
  "vifId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "hostId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "host": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "interfaceName": "mido0",
  "bgps": "http://example.org:8080/midonet-api/bgps/9bec857a-561f-43bb-bee4-a084c9cc0f50",
  "link": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
  "inboundFilterId": "f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "inboundFilter": "http://example.org:8080/midonet-api/chains/f56060f7-a2b9-4da5-ae91-a07a6311d660",
  "outboundFilterId": "54033d05-13e5-47a4-9da8-69c49138dd4b",
  "outboundFilter": "http://example.org:8080/midonet-api/chains/54033d05-13e5-47a4-9da8-69c49138dd4b",
  "portGroups": "http://example.org:8080/midonet-api/port_groups/fcd6fee4-a31d-4432-bf7e-0acd6ff021c9",
  "hostInterfacePort": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/port/afefefbc-66d1-46a0-8d49-a56c3554e9f8/hostInterfacePort",
  "vlanId": 1234
}
```


## Port Group
Port group is a group of ports. Port groups are owned by tenants. A port could belong to multiple port groups as long as they belong to the same tenant. A port group can be specified in the chain rule to filter the traffic coming from all the ports belonging to that the specified group.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8"` |
| **id** | *uuid* | A unique identifier of the resource. | `"ddd90694-4cfd-44d3-9397-fe19fd4e5ce8"` |
| **tenantId** | *uuid* | ID of the tenant that this chain belongs to. | `"7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
| **name** | *string* | Name of the port group. Unique per tenant. | `"example_port_group"` |
| **ports** | *string* | URI for port membership operations. | `"http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
### Port Group List
Get the list of port groups.

```
GET /port_groups
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/port_groups

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
    "id": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
    "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "name": "example_port_group",
    "ports": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
  }
]
```

### Port Group List (Port)
Get the list of port groups on a port

```
GET /ports/{portId}/port_groups
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ports/$PORTID/port_groups

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
    "id": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
    "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "name": "example_port_group",
    "ports": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
  }
]
```

### Port Group Info
Get the specific port group.

```
GET /port_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/port_groups/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "id": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "name": "example_port_group",
  "ports": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Port Group Create
Create a new port group.

```
POST /port_groups
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/port_groups \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "id": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "name": "example_port_group",
  "ports": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Port Group Update
Update the specific port group.

```
PUT /port_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/port_groups/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "id": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "name": "example_port_group",
  "ports": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Port Group Delete
Delete the specific port group.

```
DELETE /port_groups/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/port_groups/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "id": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "name": "example_port_group",
  "ports": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```


## Port Group Port
PortGroupPort represents membership of ports in port groups.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8"` |
| **portGroupId** | *uuid* | ID of the port group that a port is a member of. | `"ddd90694-4cfd-44d3-9397-fe19fd4e5ce8"` |
| **portId** | *uuid* | ID of the port in a port group membership. | `"afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
| **port** | *string* | URI to fetch the port. | `"http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
### Port Group Port List
Get the list of port group ports.

```
GET /port_groups/{portGroupId}/ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/port_groups/$PORTGROUPID/ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
    "portGroupId": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
    "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
    "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
  }
]
```

### Port Group Port Info
Get the specific port group port.

```
GET /port_groups/{portGroupId}/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/port_groups/$PORTGROUPID/ports/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "portGroupId": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Port Group Port Create
Create a new port group port.

```
POST /port_groups/{portGroupId}/ports
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/port_groups/$PORTGROUPID/ports \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "portGroupId": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Port Group Port Update
Update the specific port group port.

```
PUT /port_groups/{portGroupId}/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/port_groups/$PORTGROUPID/ports/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "portGroupId": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```

### Port Group Port Delete
Delete the specific port group port.

```
DELETE /port_groups/{portGroupId}/ports/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/port_groups/$PORTGROUPID/ports/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/port_groups/ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "portGroupId": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"
}
```


## Port Link
Port Link is an entity that represents an entry of the virtual link between virtual network devices in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link"` |
| **portId** | *uuid* | A unique identifier of the port. | `"afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
| **port** | *string* | A GET against this URI retrieves the port. | `"http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8"` |
| **peerId** | *uuid* | A unique identifier of the peer port. | `"0f5a458d-0ce3-45c5-b01f-884ff110bddd"` |
| **peer** | *string* | A GET against this URI retrieves the peer port. | `"http://example.org:8080/midonet-api/ports/0f5a458d-0ce3-45c5-b01f-884ff110bddd"` |
### Port Link Create
Create a new port link.

```
POST /ports/{id}/link
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/ports/$ID/link \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "peerId": "0f5a458d-0ce3-45c5-b01f-884ff110bddd",
  "peer": "http://example.org:8080/midonet-api/ports/0f5a458d-0ce3-45c5-b01f-884ff110bddd"
}
```

### Port Link Delete
Delete the specific port link.

```
DELETE /ports/{id}/link
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/ports/$ID/link \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8/link",
  "portId": "afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "port": "http://example.org:8080/midonet-api/ports/afefefbc-66d1-46a0-8d49-a56c3554e9f8",
  "peerId": "0f5a458d-0ce3-45c5-b01f-884ff110bddd",
  "peer": "http://example.org:8080/midonet-api/ports/0f5a458d-0ce3-45c5-b01f-884ff110bddd"
}
```


## Route
Route is an entity that represents a route on a virtual router in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/routes/0124f60a-ca6c-45ba-9290-982d5550bd76"` |
| **id** | *uuid* | A unique identifier of the resource. | `"0124f60a-ca6c-45ba-9290-982d5550bd76"` |
| **routerId** | *uuid* | ID of the router that this route belongs to. | `"9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
| **router** | *string* | A GET against this URI gets the router resource. | `"http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
| **type** | *string* | Type of route:      * Normal: Regular traffic forwarding route     * Reject: Drop packets and send ICMP packets back     * BlackHole: Drop packets and do not send ICMP packets back<br/> **one of:**`"Normal"` or `"Reject"` or `"BlackHole"` | `"Normal"` |
| **srcNetworkAddr** | *ipv4* | Source IP address. | `"1.2.3.4"` |
| **srcNetworkLength** | *integer* | Source network IP address length.<br/> **Range:** `0 <= value <= 32` | `24` |
| **dstNetowrkAddr** | *ipv4* | Destination IP address. | `"1.2.3.4"` |
| **dstNetworkLength** | *integer* | Destination network IP address length.<br/> **Range:** `0 <= value <= 32` | `24` |
| **weight** | *integer* | The priority weight of the route. Lower weights take precedence over higher weights. |  |
| **nextHopPort** | *uuid* | The ID of the next hop port. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **nextHopGateeway** | *string* | IP address of the gateway router to forward the traffic to. |  |
### Route List
Get the list of routes on a router.

```
GET /routers/{routerId}/routes
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/routers/$ROUTERID/routes

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/routes/0124f60a-ca6c-45ba-9290-982d5550bd76",
    "id": "0124f60a-ca6c-45ba-9290-982d5550bd76",
    "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
    "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
    "type": "Normal",
    "srcNetworkAddr": "1.2.3.4",
    "srcNetworkLength": 24,
    "dstNetowrkAddr": "1.2.3.4",
    "dstNetworkLength": 24,
    "weight": null,
    "nextHopPort": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "nextHopGateeway": null
  }
]
```

### Route Info
Get the specific route.

```
GET /route/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/route/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/routes/0124f60a-ca6c-45ba-9290-982d5550bd76",
  "id": "0124f60a-ca6c-45ba-9290-982d5550bd76",
  "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "type": "Normal",
  "srcNetworkAddr": "1.2.3.4",
  "srcNetworkLength": 24,
  "dstNetowrkAddr": "1.2.3.4",
  "dstNetworkLength": 24,
  "weight": null,
  "nextHopPort": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "nextHopGateeway": null
}
```

### Route Create
Create a new route on a router.

```
POST /routers/{routerId}/routes
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/routers/$ROUTERID/routes \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/routes/0124f60a-ca6c-45ba-9290-982d5550bd76",
  "id": "0124f60a-ca6c-45ba-9290-982d5550bd76",
  "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "type": "Normal",
  "srcNetworkAddr": "1.2.3.4",
  "srcNetworkLength": 24,
  "dstNetowrkAddr": "1.2.3.4",
  "dstNetworkLength": 24,
  "weight": null,
  "nextHopPort": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "nextHopGateeway": null
}
```

### Route Update
Update the specific route.

```
PUT /routers/{routerId}/routes/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/routers/$ROUTERID/routes/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/routes/0124f60a-ca6c-45ba-9290-982d5550bd76",
  "id": "0124f60a-ca6c-45ba-9290-982d5550bd76",
  "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "type": "Normal",
  "srcNetworkAddr": "1.2.3.4",
  "srcNetworkLength": 24,
  "dstNetowrkAddr": "1.2.3.4",
  "dstNetworkLength": 24,
  "weight": null,
  "nextHopPort": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "nextHopGateeway": null
}
```

### Route Delete
Delete the specific route.

```
DELETE /routers/{routerId}/routes/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/routers/$ROUTERID/routes/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87/routes/0124f60a-ca6c-45ba-9290-982d5550bd76",
  "id": "0124f60a-ca6c-45ba-9290-982d5550bd76",
  "routerId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "router": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "type": "Normal",
  "srcNetworkAddr": "1.2.3.4",
  "srcNetworkLength": 24,
  "dstNetowrkAddr": "1.2.3.4",
  "dstNetworkLength": 24,
  "weight": null,
  "nextHopPort": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "nextHopGateeway": null
}
```


## Router
Router is an entity that represents a virtual router device in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
| **name** | *string* | Name of the router. Must be unique within each tenant. |  |
| **tenantId** | *uuid* | ID of the tenant that owns the router. | `"7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
| **adminStateUp** | *boolean* | The administrative state of the resource. | `true` |
| **loadBalancerId** | *uuid* | Load balancer object to which it is associated with. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **loadBalancer** | *string* | A GET against this URI gets the load balancer object. | `"http://example.org/"` |
| **ports** | *string* | A URI for the resource. | `"http://example.org/"` |
| **dhcpSubnets** | *string* | A URI for the resource. | `"http://example.org/"` |
| **router** | *string* | A GET against this URI retrieves routers on this router. | `"http://example.org/"` |
| **macTable** | *string* | A GET against this URI retrieves the router's MAC table. | `"http://example.org/"` |
| **peerPorts** | *string* | A GET against this URI retrieves the interior ports attached to this router. | `"http://example.org/"` |
| **inboundFilterId** | *uuid* | ID of the filter chain to be applied for incoming packes. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **inboundFilter** | *string* | A GET against this URI retrieves the inbound filter chain. | `"http://example.org/"` |
| **outboundFilterId** | *uuid* | ID of the filter chain to be applied for outgoing packets. | `"1fcf4a17-dd31-4efc-b53b-217b086483fd"` |
| **outboundFilter** | *string* | A GET against this URI retreives the outbound filter chain. | `"http://example.org/"` |
### Router List
Get the list of routers.

```
GET /routers
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/routers

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
    "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
    "name": null,
    "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "adminStateUp": true,
    "loadBalancerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "loadBalancer": "http://example.org/",
    "ports": "http://example.org/",
    "dhcpSubnets": "http://example.org/",
    "router": "http://example.org/",
    "macTable": "http://example.org/",
    "peerPorts": "http://example.org/",
    "inboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "inboundFilter": "http://example.org/",
    "outboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
    "outboundFilter": "http://example.org/"
  }
]
```

### Router Info
Get the specific router.

```
GET /routers/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/routers/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "name": null,
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "adminStateUp": true,
  "loadBalancerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "loadBalancer": "http://example.org/",
  "ports": "http://example.org/",
  "dhcpSubnets": "http://example.org/",
  "router": "http://example.org/",
  "macTable": "http://example.org/",
  "peerPorts": "http://example.org/",
  "inboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "inboundFilter": "http://example.org/",
  "outboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "outboundFilter": "http://example.org/"
}
```

### Router Create
Create a new router.

```
POST /routers
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/routers \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "name": null,
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "adminStateUp": true,
  "loadBalancerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "loadBalancer": "http://example.org/",
  "ports": "http://example.org/",
  "dhcpSubnets": "http://example.org/",
  "router": "http://example.org/",
  "macTable": "http://example.org/",
  "peerPorts": "http://example.org/",
  "inboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "inboundFilter": "http://example.org/",
  "outboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "outboundFilter": "http://example.org/"
}
```

### Router Update
Update the specific router.

```
PUT /routers/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/routers/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "name": null,
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "adminStateUp": true,
  "loadBalancerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "loadBalancer": "http://example.org/",
  "ports": "http://example.org/",
  "dhcpSubnets": "http://example.org/",
  "router": "http://example.org/",
  "macTable": "http://example.org/",
  "peerPorts": "http://example.org/",
  "inboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "inboundFilter": "http://example.org/",
  "outboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "outboundFilter": "http://example.org/"
}
```

### Router Delete
Delete the specific router.

```
DELETE /routers/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/routers/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/routers/9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "id": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87",
  "name": null,
  "tenantId": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "adminStateUp": true,
  "loadBalancerId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "loadBalancer": "http://example.org/",
  "ports": "http://example.org/",
  "dhcpSubnets": "http://example.org/",
  "router": "http://example.org/",
  "macTable": "http://example.org/",
  "peerPorts": "http://example.org/",
  "inboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "inboundFilter": "http://example.org/",
  "outboundFilterId": "1fcf4a17-dd31-4efc-b53b-217b086483fd",
  "outboundFilter": "http://example.org/"
}
```


## Rule
Rule is an entity that represents a rule on a virtual router chain in MidoNet.  ### How L2 Address masking works  dlDstMask and dlSrcMask help reduce the number of L2 address match rules.  For example, if you specify dlDstMask to be 'ffff.0000.0000', and if dlDst is 'abcd.0000.0000', all traffic with the destination MAC address that starts with 'abcd' will be matched.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/chains/rules/7688dba0-4a55-4c8e-a005-4f84fe9eaabe"` |
| **id** | *uuid* | A unique identifier of the resource. | `"7688dba0-4a55-4c8e-a005-4f84fe9eaabe"` |
| **chainId** | *uuid* | ID of the chain that this chain belongs to. | `"cc15564b-2f0b-4579-8b4b-06c0687a7240"` |
| **condInvert** | *boolean* | Invert the conjunction of all the other predicates. | `false` |
| **dlDst** | *string* | The data link layer destination that this rule matches on. A MAC address in the form aa:bb:cc:dd:ee:ff.<br/> **pattern:** <code>^((?:[0-9a-f]{2}:){5}[0-9a-f]{2}&#124;(?:[0-9A-F]{2}:){5}[0-9A-F]{2})$</code> | `"aa:bb:cc:dd:ee:ff"` |
| **dlSrc** | *string* | The data link layer source that this rule matches on. A MAC address in the form aa:bb:cc:dd:ee:ff.<br/> **pattern:** <code>^((?:[0-9a-f]{2}:){5}[0-9a-f]{2}&#124;(?:[0-9A-F]{2}:){5}[0-9A-F]{2})$</code> | `"aa:bb:cc:dd:ee:ff"` |
| **dlType** | *integer* | Set the data link layer type (ethertype) of packets matched by this rule. The type provided is not check for validity.<br/> **Range:** `0 <= value <= 65535` | `0` |
| **dlSrcMask** | *string* | Source MAC address mask in the format xxxx.xxxx.xxxx where each x is a hexadecimal digit.<br/> **pattern:** <code>^(?:(?:[a-f0-9]{4}.){2}[a-f0-9]&#124;(?:[A-F0-9]{4}.){2}[A-F0-9])$</code> | `"1234.5678.9abc"` |
| **flowAction** | *string* | Action to take on each flow. If the type is snat, dnat, rev_snat and rev_dnat then this field is required. Must be one of accept, continue, return.<br/> **one of:**`"accept"` or `"continue"` or `"return"` | `"accept"` |
| **inPorts** | *array* | The list of (interior or exterior) ingress port UUIDs to match. | `["b3a79f36-6907-40cb-bf10-226dc1f78ba6","a01610eb-8d35-4f4b-9667-32a37b3d57b7"]` |
| **invDlDst** | *boolean* | Set whether the match on the data link layer destination should be inverted (match packets whose data link layer destination is NOT equal to dlDst). Will be stored, but ignored until dlDst is set. | `false` |
| **invDlSrc** | *boolean* | Set whether the match on the data link layer source should be inverted (match packets whose data layer link source is NOT equal to dlSrc). Will be stored, but ignored until dlSrc is set. | `false` |
| **invDlType** | *boolean* | Set whether the match on the data link layer type should be inverted (match packets whose data link layer type is NOT equal to the Ethertype set by dlType. Will be stored, but ignored until dlType is set. | `false` |
| **invInPorts** | *boolean* | Inverts the in_ports predicate. Match if the packet's ingress is NOT in in_ports. | `false` |
| **invNwDst** | *boolean* | Invert the IP dest prefix predicate. Match packets whose destination is NOT in the prefix. | `false` |
| **invNwProto** | *boolean* | Invert the nwProto predicate. Match if the packet's protocol number is not nwProto. | `false` |
| **invNwSrc** | *boolean* | Invert the IP source prefix predicate. Match packets whose source is NOT in the prefix. | `false` |
| **invOutPorts** | *boolean* | Inverts the out_ports predicate. Match if the packet's egress is NOT in out_ports. | `false` |
| **invTpDst** | *boolean* | Invert the destination TCP/UDP port range predicate. Match packets whose dest port is NOT in the range. | `false` |
| **invTpSrc** | *boolean* | Invert the source TCP/UDP port range predicate. Match packets whose source port is NOT in the range. |  |
| **jumpChainId** | *uuid* | ID of the jump chain. If the type == jump then this field is required. | `"cc15564b-2f0b-4579-8b4b-06c0687a7240"` |
| **jumpChainName** | *string* | Name of the jump chain. | `"example_jump_chain"` |
| **natTargets** | *array* | The list of nat targets. Each nat target should be an JSON object that contains the following fields:    * addressFrom: The first IP address in the range of IP addresses used as                  NAT targets   * addressTo: The last IP address in the range of IP addresses used as                NAT targets   * portFrom: The first port number in the range of port numbers used as               NAT targets   * portTo: The last port number in the range of port numbers used as NAT             targets  For an example: {"addressFrom": "1.2.3.4", "addressTo": "5.6.7.8", "portFrom": "22", "portTo": "80"}. This field is required if the type is dnat or snat. | `[{"addressFrom":"10.0.0.1","addressTo":"10.0.0.1","portFrom":80,"portTo":80},{"addressFrom":"10.0.1.1","addressTo":"10.0.1.4","portFrom":80,"portTo":80},{"addressFrom":"10.0.3.1","addressTo":"10.0.3.4","portFrom":80,"portTo":8080}]` |
| **nwDstAddress** | *ipv4* | The address part of the IP destination prefix to match. | `"1.2.3.4"` |
| **nwDstLength** | *integer* | The length of the IP destination prefix to match.<br/> **Range:** `0 <= value <= 32` | `24` |
| **nwProto** | *integer* | The value of the IP packet TOS field to match (0-255).<br/> **Range:** `0 <= value <= 255` | `0` |
| **nwSrcAddress** | *ipv4* | The length of the source IP prefix to match (number of fixed network bits). | `"1.2.3.4"` |
| **nwSrcLength** | *integer* | The length of the source IP prefix to match (number of fixed network bits).<br/> **Range:** `0 <= value <= 32` | `24` |
| **nwTos** | *integer* | The value of the IP packet TOS field to match (0-255).<br/> **Range:** `0 <= value <= 255` | `0` |
| **outPorts** | *array* | The list of (interior or exterior) egress port UUIDs to match. | `["a597b35c-1c5b-4d7a-b183-9874b60a4856","57b79c9c-559f-4f76-b210-6559d6effa19"]` |
| **portGroup** | *uuid* | ID of the port group that you want to filter traffic from. If matched, the filter action is applied to any packet coming from ports belonging to the specified port group. | `"ddd90694-4cfd-44d3-9397-fe19fd4e5ce8"` |
| **position** | *integer* | The position at which this rule should be inserted >= 1 and <= the greatest position in the chain + 1. If not specified, it is assumed to be 1.<br/> **Range:** `1 <= value` | `1` |
| **tpSrc** | *object* | A JSON representation of the Range object representing the tcp/udp source port range to match, like {"start":80,"end":400}. When creating an ICMP rule, this field should be set to the ICMP type value. The absence of a Range will be interpreted as "any". | `{"start":80,"end":400}` |
| **tpDst** | *object* | A JSON representation of the Range object representing the tcp/udp destination port range to match, like {"start":80,"end":400}. When creating an ICMP rule, this field should be set to the ICMP code value. A null value in this field will be interpreted as "any". | `{"start":80,"end":400}` |
| **fragmentPolicy** | *string* | The policy for fragmented packet handling. The accepted values are:    * "any": matches on all packets, including fragments.   * "header": matches on header fragment packet   * "nonheader": matches on fragmented non-header packets   * "unfragmented": matches only on unfragmented packets  If L4 fields are specified (tpSrc or tpDst) then only "header" and "unfragmented" are allowed, and "header" is the default. If L4 fields are not specified, "any" is the default.<br/> **default:** `"any"`<br/> **one of:**`"any"` or `"header"` or `"nonheader"` or `"unfragmented"` | `"any"` |
| **type** | *string* | Must be one of these strings: "accept", "dnat", "drop", "jump", "rev_dnat", "rev_snat", "reject", "return", "snat".<br/> **one of:**`"accept"` or `"dnat"` or `"drop"` or `"jump"` or `"rev_dnat"` or `"rev_snat"` or `"reject"` or `"return"` or `"snat"` | `"accept"` |
### Rule List
Get the list of rules.

```
GET /chains/{chainId}/rules
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/chains/$CHAINID/rules

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/chains/rules/7688dba0-4a55-4c8e-a005-4f84fe9eaabe",
    "id": "7688dba0-4a55-4c8e-a005-4f84fe9eaabe",
    "chainId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
    "condInvert": false,
    "dlDst": "aa:bb:cc:dd:ee:ff",
    "dlSrc": "aa:bb:cc:dd:ee:ff",
    "dlType": 0,
    "dlSrcMask": "1234.5678.9abc",
    "flowAction": "accept",
    "inPorts": [
      "b3a79f36-6907-40cb-bf10-226dc1f78ba6",
      "a01610eb-8d35-4f4b-9667-32a37b3d57b7"
    ],
    "invDlDst": false,
    "invDlSrc": false,
    "invDlType": false,
    "invInPorts": false,
    "invNwDst": false,
    "invNwProto": false,
    "invNwSrc": false,
    "invOutPorts": false,
    "invTpDst": false,
    "invTpSrc": null,
    "jumpChainId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
    "jumpChainName": "example_jump_chain",
    "natTargets": [
      {
        "addressFrom": "10.0.0.1",
        "addressTo": "10.0.0.1",
        "portFrom": 80,
        "portTo": 80
      },
      {
        "addressFrom": "10.0.1.1",
        "addressTo": "10.0.1.4",
        "portFrom": 80,
        "portTo": 80
      },
      {
        "addressFrom": "10.0.3.1",
        "addressTo": "10.0.3.4",
        "portFrom": 80,
        "portTo": 8080
      }
    ],
    "nwDstAddress": "1.2.3.4",
    "nwDstLength": 24,
    "nwProto": 0,
    "nwSrcAddress": "1.2.3.4",
    "nwSrcLength": 24,
    "nwTos": 0,
    "outPorts": [
      "a597b35c-1c5b-4d7a-b183-9874b60a4856",
      "57b79c9c-559f-4f76-b210-6559d6effa19"
    ],
    "portGroup": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
    "position": 1,
    "tpSrc": {
      "start": 80,
      "end": 400
    },
    "tpDst": {
      "start": 80,
      "end": 400
    },
    "fragmentPolicy": "any",
    "type": "accept"
  }
]
```

### Rule Info
Get the specific rule.

```
GET /chains/{chainId}/rules/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/chains/$CHAINID/rules/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/chains/rules/7688dba0-4a55-4c8e-a005-4f84fe9eaabe",
  "id": "7688dba0-4a55-4c8e-a005-4f84fe9eaabe",
  "chainId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "condInvert": false,
  "dlDst": "aa:bb:cc:dd:ee:ff",
  "dlSrc": "aa:bb:cc:dd:ee:ff",
  "dlType": 0,
  "dlSrcMask": "1234.5678.9abc",
  "flowAction": "accept",
  "inPorts": [
    "b3a79f36-6907-40cb-bf10-226dc1f78ba6",
    "a01610eb-8d35-4f4b-9667-32a37b3d57b7"
  ],
  "invDlDst": false,
  "invDlSrc": false,
  "invDlType": false,
  "invInPorts": false,
  "invNwDst": false,
  "invNwProto": false,
  "invNwSrc": false,
  "invOutPorts": false,
  "invTpDst": false,
  "invTpSrc": null,
  "jumpChainId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "jumpChainName": "example_jump_chain",
  "natTargets": [
    {
      "addressFrom": "10.0.0.1",
      "addressTo": "10.0.0.1",
      "portFrom": 80,
      "portTo": 80
    },
    {
      "addressFrom": "10.0.1.1",
      "addressTo": "10.0.1.4",
      "portFrom": 80,
      "portTo": 80
    },
    {
      "addressFrom": "10.0.3.1",
      "addressTo": "10.0.3.4",
      "portFrom": 80,
      "portTo": 8080
    }
  ],
  "nwDstAddress": "1.2.3.4",
  "nwDstLength": 24,
  "nwProto": 0,
  "nwSrcAddress": "1.2.3.4",
  "nwSrcLength": 24,
  "nwTos": 0,
  "outPorts": [
    "a597b35c-1c5b-4d7a-b183-9874b60a4856",
    "57b79c9c-559f-4f76-b210-6559d6effa19"
  ],
  "portGroup": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "position": 1,
  "tpSrc": {
    "start": 80,
    "end": 400
  },
  "tpDst": {
    "start": 80,
    "end": 400
  },
  "fragmentPolicy": "any",
  "type": "accept"
}
```

### Rule Create
Create a new rule.

```
POST /chains/{chainId}/rules/{id}
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/chains/$CHAINID/rules/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/chains/rules/7688dba0-4a55-4c8e-a005-4f84fe9eaabe",
  "id": "7688dba0-4a55-4c8e-a005-4f84fe9eaabe",
  "chainId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "condInvert": false,
  "dlDst": "aa:bb:cc:dd:ee:ff",
  "dlSrc": "aa:bb:cc:dd:ee:ff",
  "dlType": 0,
  "dlSrcMask": "1234.5678.9abc",
  "flowAction": "accept",
  "inPorts": [
    "b3a79f36-6907-40cb-bf10-226dc1f78ba6",
    "a01610eb-8d35-4f4b-9667-32a37b3d57b7"
  ],
  "invDlDst": false,
  "invDlSrc": false,
  "invDlType": false,
  "invInPorts": false,
  "invNwDst": false,
  "invNwProto": false,
  "invNwSrc": false,
  "invOutPorts": false,
  "invTpDst": false,
  "invTpSrc": null,
  "jumpChainId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "jumpChainName": "example_jump_chain",
  "natTargets": [
    {
      "addressFrom": "10.0.0.1",
      "addressTo": "10.0.0.1",
      "portFrom": 80,
      "portTo": 80
    },
    {
      "addressFrom": "10.0.1.1",
      "addressTo": "10.0.1.4",
      "portFrom": 80,
      "portTo": 80
    },
    {
      "addressFrom": "10.0.3.1",
      "addressTo": "10.0.3.4",
      "portFrom": 80,
      "portTo": 8080
    }
  ],
  "nwDstAddress": "1.2.3.4",
  "nwDstLength": 24,
  "nwProto": 0,
  "nwSrcAddress": "1.2.3.4",
  "nwSrcLength": 24,
  "nwTos": 0,
  "outPorts": [
    "a597b35c-1c5b-4d7a-b183-9874b60a4856",
    "57b79c9c-559f-4f76-b210-6559d6effa19"
  ],
  "portGroup": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "position": 1,
  "tpSrc": {
    "start": 80,
    "end": 400
  },
  "tpDst": {
    "start": 80,
    "end": 400
  },
  "fragmentPolicy": "any",
  "type": "accept"
}
```

### Rule Delete
Delete the specific rule.

```
DELETE /chains/{chainId}/rules/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/chains/$CHAINID/rules/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/chains/rules/7688dba0-4a55-4c8e-a005-4f84fe9eaabe",
  "id": "7688dba0-4a55-4c8e-a005-4f84fe9eaabe",
  "chainId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "condInvert": false,
  "dlDst": "aa:bb:cc:dd:ee:ff",
  "dlSrc": "aa:bb:cc:dd:ee:ff",
  "dlType": 0,
  "dlSrcMask": "1234.5678.9abc",
  "flowAction": "accept",
  "inPorts": [
    "b3a79f36-6907-40cb-bf10-226dc1f78ba6",
    "a01610eb-8d35-4f4b-9667-32a37b3d57b7"
  ],
  "invDlDst": false,
  "invDlSrc": false,
  "invDlType": false,
  "invInPorts": false,
  "invNwDst": false,
  "invNwProto": false,
  "invNwSrc": false,
  "invOutPorts": false,
  "invTpDst": false,
  "invTpSrc": null,
  "jumpChainId": "cc15564b-2f0b-4579-8b4b-06c0687a7240",
  "jumpChainName": "example_jump_chain",
  "natTargets": [
    {
      "addressFrom": "10.0.0.1",
      "addressTo": "10.0.0.1",
      "portFrom": 80,
      "portTo": 80
    },
    {
      "addressFrom": "10.0.1.1",
      "addressTo": "10.0.1.4",
      "portFrom": 80,
      "portTo": 80
    },
    {
      "addressFrom": "10.0.3.1",
      "addressTo": "10.0.3.4",
      "portFrom": 80,
      "portTo": 8080
    }
  ],
  "nwDstAddress": "1.2.3.4",
  "nwDstLength": 24,
  "nwProto": 0,
  "nwSrcAddress": "1.2.3.4",
  "nwSrcLength": 24,
  "nwTos": 0,
  "outPorts": [
    "a597b35c-1c5b-4d7a-b183-9874b60a4856",
    "57b79c9c-559f-4f76-b210-6559d6effa19"
  ],
  "portGroup": "ddd90694-4cfd-44d3-9397-fe19fd4e5ce8",
  "position": 1,
  "tpSrc": {
    "start": 80,
    "end": 400
  },
  "tpDst": {
    "start": 80,
    "end": 400
  },
  "fragmentPolicy": "any",
  "type": "accept"
}
```


## System State
System State specifies parameters for the various states the deployment might be in. You may modify the system state to make limited changes to the behavior of midonet. For example, changing the "state" field to "UPGRADE" will cause the spawning of new midolman agents to abort.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **state** | *string* | Setting the state field to "UPGRADE" will put the midolman into "upgrade mode", which will cause all new midolman agents starting up in the deployment to abort the start up process. This is used during deployment wide upgrades to prevent unexpected startups of any midolman agent that might have the wrong version. This state can be reversed by setting the upgrade field to "ACTIVE". The deployment is not in upgrade state by default.<br/> **one of:**`"ACTIVE"` or `"UPGRADE"` | `"ACTIVE"` |
| **availability** | *string* | Setting the availability to "READONLY" will cause most API requests to be rejected. The exceptions are only administrative APIs that don't affect the topology: system_state and write_version. This is meant to let the operator stop REST API requests while performing maintenance or upgrades. Setting the availability to "READWRITE" (the default value) allows both GETs and PUT/POST API requests.<br/> **one of:**`"READONLY"` or `"READWRITE"` | `"READONLY"` |
### System State Info
Get the system state.

```
GET /system_state
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/system_state

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "state": "ACTIVE",
  "availability": "READONLY"
}
```

### System State Update
Update the system state.

```
PUT /system_state
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/system_state \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "state": "ACTIVE",
  "availability": "READONLY"
}
```


## Tenant
Represents a tenant, or a group of users, in the identity services.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/tenants/7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
| **id** | *uuid* | A unique identifier of the resource. | `"7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
| **name** | *string* | Name of the tenant in the identity system. | `"exmple_tenant"` |
| **bridges** | *string* | A GET against this URI retrieves tenant's bridges. | `"http://example.org:8080/midonet-api/bridges?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
| **chains** | *string* | A GET against this URI retrieves tenant's chains. | `"http://example.org:8080/midonet-api/chains?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
| **port_groups** | *string* | A GET against this URI retrieves tenant's port groups | `"http://example.org:8080/midonet-api/port_groups?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
| **reouters** | *string* | A GET against this URI retrieves tenant's routers. | `"http://example.org:8080/midonet-api/routers?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"` |
### Tenant List
Get the list of tenants.

```
GET /tenants
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tenants

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/tenants/7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "id": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "name": "exmple_tenant",
    "bridges": "http://example.org:8080/midonet-api/bridges?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "chains": "http://example.org:8080/midonet-api/chains?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "port_groups": "http://example.org:8080/midonet-api/port_groups?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
    "reouters": "http://example.org:8080/midonet-api/routers?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"
  }
]
```

### Tenant Info
Get the specific tenant.

```
GET /tenants/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tenants/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tenants/7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "id": "7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "name": "exmple_tenant",
  "bridges": "http://example.org:8080/midonet-api/bridges?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "chains": "http://example.org:8080/midonet-api/chains?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "port_groups": "http://example.org:8080/midonet-api/port_groups?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9",
  "reouters": "http://example.org:8080/midonet-api/routers?tenant_id=7ae3e43d-1964-46ea-bf09-cd8fbdfb5cc9"
}
```


## Token
A token represents the info required for the 'token authentication' method. It can NOT be retrieved through a GET request, but instead must be retrieved in the body or the header of a login request.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **key** | *string* | The authentication token. | `"baz"` |
| **expires** | *date-time* | The expiration date for the authentication token. | `"Fri, 02 July 2014 1:00:00 GMT"` |
### Token Login
Post a login information.

```
POST /login
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/login \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "key": "baz",
  "expires": "Fri, 02 July 2014 1:00:00 GMT"
}
```


## Tunnel Zone
Tunnel zone represents a group in which hosts can be included to form an isolated zone for tunneling. They must have unique, case insensitive names per type.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac"` |
| **id** | *uuid* | A unique identifier of the resource. | `"fe715922-4f87-437d-8638-d45910d2b1ac"` |
| **name** | *string* | The name of the resource. | `"example_tunnel_zone"` |
| **type** | *string* | Tunnel type. Currently this value can only be "GRE".<br/> **one of:**`"GRE"` | `"GRE"` |
### Tunnel Zone List
Get the list of tunnel zones.

```
GET /tunnel_zones
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tunnel_zones

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
    "id": "fe715922-4f87-437d-8638-d45910d2b1ac",
    "name": "example_tunnel_zone",
    "type": "GRE"
  }
]
```

### Tunnel Zone Info
Get the specific tunnel zone.

```
GET /tunnel_zones/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tunnel_zones/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "id": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "name": "example_tunnel_zone",
  "type": "GRE"
}
```

### Tunnel Zone Create
Create a new tunnel zone.

```
POST /tunnel_zones
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/tunnel_zones \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "id": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "name": "example_tunnel_zone",
  "type": "GRE"
}
```

### Tunnel Zone Update
Update the specific tunnel zone.

```
PUT /tunnel_zones/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/tunnel_zones/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "id": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "name": "example_tunnel_zone",
  "type": "GRE"
}
```

### Tunnel Zone Delete
Delete the specific tunnel zone.

```
DELETE /tunnel_zones/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/tunnel_zones/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "id": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "name": "example_tunnel_zone",
  "type": "GRE"
}
```


## Tunnel Zone Host
Hosts in the same tunnel zone share the same tunnel configurations, and they are allowed to create tunnels among themselves.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **id** | *uuid* | A unique identifier of the resource. | `"07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **tunnelZoneId** | *uuid* | ID of the tunnel zone that the host is a member of. | `"fe715922-4f87-437d-8638-d45910d2b1ac"` |
| **tunnelZone** | *string* | A GET against this URI retrieves the tunnel zone | `"http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac"` |
| **hostId** | *uuid* | ID of the host that you want to add to a tunnel zone. | `"07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **host** | *string* | A GET against this URI retrieves the host. | `"http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3"` |
| **ipAddress** | *ipv4* | IP address to use for the GRE tunnels from this host. | `"1.2.3.4"` |
### Tunnel Zone Host List CapwapTunnelZoneHost
Get the list of tunnel zones hosts.

```
GET /tunnel_zones/{tunnelZoneId}/hosts
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tunnel_zones/$TUNNELZONEID/hosts

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
    "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
    "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
    "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
    "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
    "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
    "ipAddress": "1.2.3.4"
  }
]
```

### Tunnel Zone Host List GreTunnelZoneHost
Get the list of tunnel zones hosts.

```
GET /tunnel_zones/{tunnelZoneId}/hosts
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tunnel_zones/$TUNNELZONEID/hosts

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "ipAddress": "1.2.3.4"
}
```

### Tunnel Zone Host List IpsecTunnelZoneHost
Get the list of tunnel zones hosts.

```
GET /tunnel_zones/{tunnelZoneId}/hosts
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tunnel_zones/$TUNNELZONEID/hosts

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "ipAddress": "1.2.3.4"
}
```

### Tunnel Zone Host Info CapwapTunnelZoneHost
Get the specific tunnel zone host.

```
GET /tunnel_zones/{tunnelZondId}/hosts/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tunnel_zones/$TUNNELZONDID/hosts/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "ipAddress": "1.2.3.4"
}
```

### Tunnel Zone Host Info GreTunnelZoneHost
Get the specific tunnel zone host.

```
GET /tunnel_zones/{tunnelZondId}/hosts/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tunnel_zones/$TUNNELZONDID/hosts/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "ipAddress": "1.2.3.4"
}
```

### Tunnel Zone Host Info IpsecTunnelZoneHost
Get the specific tunnel zone host.

```
GET /tunnel_zones/{tunnelZondId}/hosts/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/tunnel_zones/$TUNNELZONDID/hosts/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "ipAddress": "1.2.3.4"
}
```

### Tunnel Zone Host Create
Create a new tunnel zone host.

```
POST /tunnel_zones/{tunnelZondId}/hosts
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/tunnel_zones/$TUNNELZONDID/hosts \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "ipAddress": "1.2.3.4"
}
```

### Tunnel Zone Host Update
Update the specific tunnel zone host.

```
PUT /tunnel_zones/{tunnelZoneId}/hosts/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/tunnel_zones/$TUNNELZONEID/hosts/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "ipAddress": "1.2.3.4"
}
```

### Tunnel Zone Host Delete
Delete the specific tunnel zone.

```
DELETE /tunnel_zones/{tunnelZoneId}/hosts/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/tunnel_zones/$TUNNELZONEID/hosts/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "id": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "tunnelZone": "http://example.org:8080/midonet-api/tunnel_zones/fe715922-4f87-437d-8638-d45910d2b1ac",
  "hostId": "07743a54-fd7d-430e-b7b1-320843b005e3",
  "host": "http://example.org:8080/midonet-api/hosts/07743a54-fd7d-430e-b7b1-320843b005e3",
  "ipAddress": "1.2.3.4"
}
```


## VIP
A VIP is an entity that represents a virtual IP address device for use with load balancers in MidoNet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips/eece7d61-ab29-4ed0-88db-d7b852a798c9"` |
| **id** | *uuid* | A unique identifier of the resource. If this field is omitted in the POST request, a random UUID is generated. | `"eece7d61-ab29-4ed0-88db-d7b852a798c9"` |
| **loadBalancerId** | *uuid* | Load balancer object to which it is associated with. This is deduced from the pool that it is associated with. | `"b6fac5fc-2d3f-4a81-9eba-feab374cb310"` |
| **loadBalancer** | *string* | A GET against this URI gets the load balancer object. | `"http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310"` |
| **poolId** | *uuid* | ID of the pool. | `"31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6"` |
| **pool** | *string* | A GET against this URI gets the pool object. | `"http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6"` |
| **address** | *ipv4* | IP address of the VIP. | `"1.2.3.4"` |
| **protocolPort** | *integer* | Port of the VIP.<br/> **Range:** `0 <= value <= 65535` | `80` |
| **sessionPersistence** | *string* | Session persistence of the VIP (Only “SOURCE_IP” allowed). This property can be null.<br/> **one of:**`"SOURCE_IP"` or `"NONE"` | `"SOURCE_IP"` |
| **adminSteteUp** | *boolean* | The administrative state of the resource. | `true` |
### VIP List
Get the list of VIPs on a load balancer.

```
GET /load_balancers/{loadBalancerId}/vips
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/load_balancers/$LOADBALANCERID/vips

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips/eece7d61-ab29-4ed0-88db-d7b852a798c9",
    "id": "eece7d61-ab29-4ed0-88db-d7b852a798c9",
    "loadBalancerId": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
    "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
    "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
    "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
    "address": "1.2.3.4",
    "protocolPort": 80,
    "sessionPersistence": "SOURCE_IP",
    "adminSteteUp": true
  }
]
```

### VIP Info
Get the specific VIP on a load blancer.

```
GET /load_balancers/{loadBalancerId}/vips/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/load_balancers/$LOADBALANCERID/vips/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips/eece7d61-ab29-4ed0-88db-d7b852a798c9",
  "id": "eece7d61-ab29-4ed0-88db-d7b852a798c9",
  "loadBalancerId": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "address": "1.2.3.4",
  "protocolPort": 80,
  "sessionPersistence": "SOURCE_IP",
  "adminSteteUp": true
}
```

### VIP Create
Create a new VIP on a load balancer.

```
POST /load_balancers/{loadBalancerId}/vips
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/load_balancers/$LOADBALANCERID/vips \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips/eece7d61-ab29-4ed0-88db-d7b852a798c9",
  "id": "eece7d61-ab29-4ed0-88db-d7b852a798c9",
  "loadBalancerId": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "address": "1.2.3.4",
  "protocolPort": 80,
  "sessionPersistence": "SOURCE_IP",
  "adminSteteUp": true
}
```

### VIP Update
Update the specific VIP on a load balancer.

```
PUT /load_balancers/{loadBalancerId}/vips/{id}
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/load_balancers/$LOADBALANCERID/vips/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips/eece7d61-ab29-4ed0-88db-d7b852a798c9",
  "id": "eece7d61-ab29-4ed0-88db-d7b852a798c9",
  "loadBalancerId": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "address": "1.2.3.4",
  "protocolPort": 80,
  "sessionPersistence": "SOURCE_IP",
  "adminSteteUp": true
}
```

### VIP Delete
Delete the specific VIP on a load balancer.

```
DELETE /load_balancers/{loadBalancerId}/vips/{id}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/load_balancers/$LOADBALANCERID/vips/$ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310/vips/eece7d61-ab29-4ed0-88db-d7b852a798c9",
  "id": "eece7d61-ab29-4ed0-88db-d7b852a798c9",
  "loadBalancerId": "b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "loadBalancer": "http://example.org:8080/midonet-api/load_balancers/b6fac5fc-2d3f-4a81-9eba-feab374cb310",
  "poolId": "31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "pool": "http://example.org:8080/midonet-api/load_balancers/59e72865-57d2-4eda-99e7-98bcf878bc52/pools/31ebc9bc-83a3-4a3c-b2a8-94a3cd9059a6",
  "address": "1.2.3.4",
  "protocolPort": 80,
  "sessionPersistence": "SOURCE_IP",
  "adminSteteUp": true
}
```


## VTEP
Midonet representation of a VXLAN Tunnel EndPoint, or VTEP, which allows you to merge a Midonet L2 network with physical L2 network over an IP tunnel. Once you create the Midonet VTEP representation of your external VTEP, you can bind Neutron networks to the VTEP's ports.  All properties other than those required in POST are obtained from the external VTEP configuration and not controlled by Midonet.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/vteps/10.0.1.1"` |
| **managementIp** | *ipv4* | The VTEP's IP address. | `"1.2.3.4"` |
| **managementPort** | *integer* | The TCP port used for management connections to the VTEP.<br/> **Range:** `0 <= value <= 65535` | `80` |
| **tunnelZoneId** | *uuid* | ID of the tunnel zone used by Midonet to send and receive tunneled traffic to and from the VTEP. | `"fe715922-4f87-437d-8638-d45910d2b1ac"` |
| **connectionState** | *string* | Indicates whether Midonet could successfully connect to the VTEP. Possible values are CONNECTED and ERROR.<br/> **one of:**`"CONNECTED"` or `"ERROR"` | `"CONNECTED"` |
| **name** | *string* | VTEP's name. | `"example_vtep"` |
| **description** | *string* | VTEP's description. | `"An example description for the VTEP."` |
| **tunnelIpAddrs** | *array* | List of IP addresses available to Midonet to tunnel to the VTEP. | `["10.0.1.1","10.0.2.1"]` |
| **binding** | *string* | A GET on this URI retrieves a list of the VTEP's bindings to Neutron networks. | `"http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings"` |
| **bindingTemplate** | *string* | Template for the URI to the VTEP's individual bindings. | `"http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/{id}"` |
| **ports** | *string* | A GET on this URI retrieves a list of the VTEP's ports. | `"http://example.org:8080/midonet-api/vteps/10.0.1.1/ports"` |
### VTEP List
Get the list of VTEPs.

```
GET /vteps
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/vteps

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1",
    "managementIp": "1.2.3.4",
    "managementPort": 80,
    "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
    "connectionState": "CONNECTED",
    "name": "example_vtep",
    "description": "An example description for the VTEP.",
    "tunnelIpAddrs": [
      "10.0.1.1",
      "10.0.2.1"
    ],
    "binding": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings",
    "bindingTemplate": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/{id}",
    "ports": "http://example.org:8080/midonet-api/vteps/10.0.1.1/ports"
  }
]
```

### VTEP Info
Get the specific VTEP.

```
GET /vteps/{id}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/vteps/$ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1",
  "managementIp": "1.2.3.4",
  "managementPort": 80,
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "connectionState": "CONNECTED",
  "name": "example_vtep",
  "description": "An example description for the VTEP.",
  "tunnelIpAddrs": [
    "10.0.1.1",
    "10.0.2.1"
  ],
  "binding": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings",
  "bindingTemplate": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/{id}",
  "ports": "http://example.org:8080/midonet-api/vteps/10.0.1.1/ports"
}
```

### VTEP Create
Create a new VTEP.

```
POST /vteps
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/vteps \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1",
  "managementIp": "1.2.3.4",
  "managementPort": 80,
  "tunnelZoneId": "fe715922-4f87-437d-8638-d45910d2b1ac",
  "connectionState": "CONNECTED",
  "name": "example_vtep",
  "description": "An example description for the VTEP.",
  "tunnelIpAddrs": [
    "10.0.1.1",
    "10.0.2.1"
  ],
  "binding": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings",
  "bindingTemplate": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/{id}",
  "ports": "http://example.org:8080/midonet-api/vteps/10.0.1.1/ports"
}
```


## VTEP Binding
Bindings between a VTEP port/vlanId and a Neutron network. Creating a binding creates an IP tunnel through which L2 traffic can pass between the VTEP and Neutron network.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **uri** | *string* | A GET against this URI refreshes the representation of this resource. | `"http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/example_port/1234"` |
| **portName** | *string* | The name of the VTEP port to be bound to the Neutron network. | `"example_port"` |
| **vlanId** | *integer* | The VLAN ID with which traffic from the VTEP to Midonet will be tagged. Must be between 0 and 4095 inclusive. If 0, then traffic will not be tagged with a VLAN ID.<br/> **Range:** `0 <= value <= 4095` | `1234` |
| **networkId** | *uuid* | The ID of the Neutron network to which the VLAN's port is to be bound. A VXLAN port will be created on the bridge if it does not already have one, and the binding will be added to the bridge's VXLAN port.  It is an error to attempt bind a Neutron network to more than one VTEP, but a network may have multiple bindings to a single VTEP, and a VTEP may  have bindings to multiple networks. | `"9a59b96e-dcee-4695-b7f4-fb5e3d349f87"` |
### VTEP Binding List
Get the list of VTEP bindings on a VTEP.

```
GET /vteps/{managementIp}/bindings
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/vteps/$MANAGEMENTIP/bindings

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/example_port/1234",
    "portName": "example_port",
    "vlanId": 1234,
    "networkId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87"
  }
]
```

### VTEP Binding Info
Get the specific VTEP binding on a VTEP.

```
GET /vteps/{managementIp}/bindings/{portName}/{vlanId}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/vteps/$MANAGEMENTIP/bindings/$PORTNAME/$VLANID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/example_port/1234",
  "portName": "example_port",
  "vlanId": 1234,
  "networkId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87"
}
```

### VTEP Binding List
Get the list of VTEP bindings on a VXLAN port.

```
GET /ports/{vxLanPortId}/bindings
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ports/$VXLANPORTID/bindings

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/example_port/1234",
    "portName": "example_port",
    "vlanId": 1234,
    "networkId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87"
  }
]
```

### VTEP Binding Info
Get the specific VTEP binding on a VTEP.

```
GET /ports/{vxLanPortId}/bindings/{portName}/{vlanId}
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/ports/$VXLANPORTID/bindings/$PORTNAME/$VLANID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/example_port/1234",
  "portName": "example_port",
  "vlanId": 1234,
  "networkId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87"
}
```

### VTEP Binding Create
Create a new VTEP binding on a VTEP.

```
POST /vteps/{managementIp}/bindings
```


#### Curl Example
```bash
$ curl -n -X POST https://example.org/midonet-api/vteps/$MANAGEMENTIP/bindings \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/example_port/1234",
  "portName": "example_port",
  "vlanId": 1234,
  "networkId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87"
}
```

### VTEP Binding Delete
Delete the specific VTEP binding on a VTEP.

```
DELETE /vteps/{managementIp}/bindings/{portNam}/{vlanId}
```


#### Curl Example
```bash
$ curl -n -X DELETE https://example.org/midonet-api/vteps/$MANAGEMENTIP/bindings/$PORTNAM/$VLANID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "uri": "http://example.org:8080/midonet-api/vteps/10.0.1.1/bindings/example_port/1234",
  "portName": "example_port",
  "vlanId": 1234,
  "networkId": "9a59b96e-dcee-4695-b7f4-fb5e3d349f87"
}
```


## VTEP Port
Gets the name and description of all ports on the specified VTEP.a

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **name** | *string* | The port's name. | `"example_port"` |
### VTEP Port List
Get the list of VTEP ports.

```
GET /vteps/10.0.1.1/ports
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/vteps/10.0.1.1/ports

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "name": "example_port"
  }
]
```


## Write Version
Write Version specifies the version information that is relevant to the midonet deployment as a whole. For example, the "version" field specifies the version of the topology information that all midolman agents must write to, regardless of that midolman agent's version.

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **version** | *string* | The version field determines the version of the topology data that the midolman agents will be writing. This matters during upgrade operations where we will change the write version only after all midolman agents are upgraded. The format of the version field is '[major].[minor]', where 'major' is the Major version, and 'minor' is the minor version. For example '1.2'.<br/> **pattern:** <code>^d+.d+$</code> | `"1.2"` |
### Write Version Info
Get the write version.

```
GET /write_version
```


#### Curl Example
```bash
$ curl -n -X GET https://example.org/midonet-api/write_version

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "version": "1.2"
}
```

### Write Version Update
Update the write version.

```
PUT /write_version
```


#### Curl Example
```bash
$ curl -n -X PUT https://example.org/midonet-api/write_version \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "version": "1.2"
}
```


