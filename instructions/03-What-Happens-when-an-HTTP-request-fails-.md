# What Happens when an HTTP request fails?

## Learning goal: understand what happens when an HTTP request fails.

<details><summary>What would the server response code be if you tried to fetch a nonexistent URL on the random word generator site?  Try it using the procedure above.</summary><p><blockquote> The HTTP status code is 404.  The words "Not found" after the status  code are there for human readability; only the 3-digit status code is officially required. </blockquote></p></details>


What other HTTP error codes exist?  Use Wikipedia or another resource to learn the meanings of some of the most common:  200, 301, 302, 400, 404, 500.  Note that these are "families" of statuses: all 2xx statuses mean "it worked", all 3xx are "redirect", and so on.

<details><summary>Both 4xx and 5xx headers indicate error conditions.  What is the main difference between 4xx and 5xx?</summary><p><blockquote>4xx errors are the server actually responding "Sorry, no dice."  5xx errors occur when something went so severely sideways--for example, the app server crashed, or the SaaS app running on the server raised an unhandled exception--that the HTTP server layer, which just handles traffic to and from the app, had to take over and say "Sorry, the app is too hosed to even tell you that it's hosed." </blockquote></p></details>

---

[← Understand HTTP Request and Response](02-Understand-HTTP-Request-and-Response.md) | [Contents](README.md) | [What is a Request Body? →](04-What-is-a-Request-Body-.md)
