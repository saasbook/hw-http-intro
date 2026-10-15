# Intro to HTTP and URIs

## Learning Goals

* Use the command-line utilities `curl` and `nc` to experiment with and learn about HTTP and cookies

* Understand the basics of how HTTP requests and responses are constructed, and the interaction between a SaaS client and server using HTTP

* Understand some of the most common HTTP error codes and what they mean

* Understand how cookies are managed between clients and servers

## Prerequisites

You will need to know how to open a _terminal_ or _shell_ window in your computing environment, and how to view and edit files. Throughout this exercise, we will refer to this window as the shell window; the commands you type at its prompt are shell commands, that is, they tell the shell to run a program and display the output.

## Setup

In the beginning was the command line, and that's where we'll be for this intro to HTTP.  We will use two command-line tools. [cURL](https://en.wikipedia.org/wiki/CURL) (pronounced "curl") to act as a SaaS client, and [netcat](https://en.wikipedia.org/wiki/Netcat) (pronounced "netcat") to act as a SaaS server.

We will also be working with two real web sites: a [random-word generator](http://randomword.saasbook.info) that will also be featured in a future assignment, and a simple [cookie demo site](https://github.com/saasbook/simple-cookie-demo) written just for this assignment and deployed on Heroku.

Start by visiting the random word generator in your favorite browser to get a "user's view" of what's on the front page.

---

[Contents](README.md) | [Understand HTTP Request and Response →](02-Understand-HTTP-Request-and-Response.md)
