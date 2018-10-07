# Intro to HTTP and URIs

## Learning Goals

* Understand the basics of how HTTP requests and responses are
constructed, and the interaction between a SaaS client and server
using HTTP

* Understand what an HTTP redirect is and when it occurs

* Understand some of the most common HTTP error codes and what they mean

* Understand how cookies are managed between clients and servers

* Understand how a request body can be used to submit information such as
the contents of fill-in form from a client to a server

* Use the command-line utilities `curl` and `nc` to experiment with
and learn about HTTP and cookies

## Setup

2 terminal windows, one for `nc` and one for `curl`

## Learning goal: understand basic parts of an HTTP request and response

what do client headers look like?  what is diff between client headers
from curl vs your favorite browser?

what do server headers look like?

Some server headers are required; others optional.  Same with client.

## Learning goal: understand what happens when an HTTP request fails.

error vs OK response. what other codes exist?  what is a redirect?

Force a network error.  What's the difference between how the browser
handles a network-level error vs. an application-level error?

## Learning goal: understand the effect of HTTP being stateless, and the role of cookies

What happens if you disable cookies and try to log in to a site?  Now
enable them and try again.  Explain what's going on.

What happens if you tamper with the value of a cookie?

OPT: How long can a cookie legally  be? What happens if you violate this?



## Learning goal: understand concept of request body

submit a web form.  what does it look like when you submit it?  what
determines the route (verb + URI) used for form submission?  how is it
different from the route used to actually retrieve the form?  (Key
concept: route consists of both verb and URI)

it is allowed with POST/PUT/PATCH but not with GET/DELETE.

Can you get the web browser to generate a route that uses PUT, PATCH,
or DELETE?
