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

We will also be working with two real web sites: a
[random-word generator](http://randomword.saasbook.info) that will also be featured in a future assignment, and
a simple [cookie demo site](https://github.com/saasbook/simple-cookie-demo)
written just for this assignment and deployed on Heroku.


Start by visiting the random word generator in your favorite browser 
to get a "user's view" of what's on the front page.

## Learning goal: understand basic parts of an HTTP request and response

The most basic use of `curl` is to issue an HTTP GET or POST to a
site, so try `curl 'http://randomword.saasbook.info'` and verify that what
you see printed could plausibly correspond to the page content you
viewed in your browser previously.  (The single quotes are not
technically necessary in this case, but you should get used to using
them with `curl`, because URIs will often have special characters in
them, such as `?` or `#`, that would be interpreted in special ways by
the Unix shell if they're not protected by single quotes.) 

Save the contents of the above `curl` command to a file and view the file as a browser would render it.  

Hint 1: adding `>filename` to the end of a shell command line causes the command's output to be stored in that file rather than displayed in the terminal window.

Hint 2: Previewing file in a browser:
  | Local computer | Codio |
  |-----|------|
  | If you are saving files on your own computer's hard drive, store the command output in a file with an extension .html and open the created file with your browser.   | When you create or save files they appear in a "file tree" down the left-hand side; you can open files in the editor by clicking or double-clicking on the file's name. To preview a file in a browser, right-click and select "Preview static" |

<details><summary>  What are two main differences between the preview you see and what you saw in a "normal" Web browser? What explains these differences?  </summary>  <p><blockquote>  There is no picture and no visual styling of the page elements, because both the picture and the stylesheet (.css file) have to be loaded separately.  The HTTP request you made only loaded the main HTML file.  In a regular browser, the browser would automatically follow the links to download and display the image, and to download the stylesheet file and apply the styling information. </blockquote></p></details>

Now let's see what the server thinks a request looks like.  To do this, in another Terminal tab or window, we will pretend to be a Web server listening on port 8081.

Tell Netcat to listen on port 8081: `nc -l 8081`

(As with most Unix command-line programs, you can say `nc --help` to get a listing of other options, or `man nc` to view its detailed "manual page.")

<details><summary> Assuming you're running `curl` from another shell (on the same Codio workspace, if applicable), what URL will you have to pass to `curl` to try to access your fake server, and why? </summary><p><blockquote><code>http://localhost:8081</code> is the URL.  Localhost always means "this same machine" and 8081 is the port number.  Without the port number, the default would be 80, which is the IANA default port for Web servers (or 443 for HTTPS-secured servers).  You could also use localhost's special IP address directly: <code>http://127.0.0.1:8081</code> would also work.  </blockquote></p></details>

Visit your "fake" server with `curl` and the correct URL.  Your "fake" server will receive the HTTP client request.


<details><summary>The first line of the request identifies which URL the client wants to retrieve.  Why don't you see `http://localhost:8081` anywhere on that line?</summary><p><blockquote>The hostname part of the URL tells the browser (or other client) which protocol to use (HTTP) and which server and port to contact (port 8081 on localhost). Once the server is contacted, the client just needs to tell it the remainder of the URL (the path portion) that it wants to retrieve.  </blockquote></p></details>

Make a note of which headers you see: this is how a real Web server perceives a connection from `curl`.

Now that you've seen what an HTTP request looks like from the server's point of view, let's see what the response looks like from the client's point of view.  In particular, `curl` just prints out the content sent back from the server, but we'd like to see the server headers.  Try `curl --help` to see the help and verify that the command line `curl -i 'http://randomword.saasbook.info'` will display BOTH  the server's response headers AND then the response body.

<details><summary> Based on the server headers, what is the server's HTTP response code giving the status of the client's request, and what version of the HTTP protocol did the server use to respond to the client?</summary><p><blockquote>The first line tells us that HTTP 1.1 was used, and that the request succeeded with code 200.</blockquote></p></details>


<details><summary> Any given Web request might return an HTML page, an image, or a number of other types of entities.  Is there anything in the headers that you think tells the client how to interpret the result? </summary><p><blockquote>The <code>Content-Type</code> header in this case tells the client that the content returned is an HTML page.</blockquote></p></details>



## Learning goal: understand what happens when an HTTP request fails.

<details><summary>What would the server response code be if you tried
to fetch a nonexistent URL on the random word generator site?  Try it
using the procedure above.</summary><p><blockquote> The HTTP status
code is 404.  The words "Not found" after the status  code are there
for human readability; only the 3-digit status code is officially
required. </blockquote></p></details> 

What other HTTP error codes exist?  Use Wikipedia or another resource
to learn the meanings of some of the most common:  200, 301, 302, 400,
404, 500.  Note that these are "families" of statuses: all 2xx
statuses mean "it worked", all 3xx are "redirect", and so on. 


<details><summary>Both 4xx and 5xx headers indicate error conditions.  What is the main difference between 4xx and 5xx?</summary><p><blockquote>4xx errors are the server actually responding "Sorry, no dice."  5xx errors occur when something went so severely sideways--for example, the app server crashed, or the SaaS app running on the server raised an unhandled exception--that the HTTP server layer, which just handles traffic to and from the app, had to take over and say "Sorry, the app is too hosed to even tell you that it's hosed." </blockquote></p></details>



## Learning goal: understand concept of request body

Next we will create a simple HTML form that you can post from your browser and intercept it with Netcat as above, so you can see what a form posting looks like to a Web server.  This is relevant because in your own SaaS apps you will have to work with submitted form data; while most frameworks like Sinatra and Rails do a nice job for you of parsing and pre-digesting such form data in order to make it conveniently available to your app, it is worth understanding what that data normally looks like before such processing.

Once again, start `nc -l 8081` to listen on port 8081.

Create and save (ideally with extension `.html`) the following minimal file:

```html
<!DOCTYPE html>
<html>
<head>
</head>
<body>
  <form method="post" action="FAKE-SERVER-URL-HERE">
    <label>Email:</label>
    <input type="text" name="email">
    <label>Password:</label>
    <input type="password" name="password">
    <input type="hidden" name="secret_info" value="secret_value">
    <input type="submit" name="login" value="Log In!">
  </form>
</body>
</html>
```

<details><summary>An HTML form when submitted generates an HTTP `POST` request from the browser.  In order to reach your fake server, with what URL should you replace FAKE-SERVER-URL-HERE in the above file?</summary> <p><blockquote> **Local computer:** `http://localhost:8081` <br> **Codio:** `https://box-name-8081.codio.io/` where box-name is the two-word phrase you see in your terminal prompt. Example `codio@emerald-tripod:~/workspace$` would be `https://emerald-tripod-8081.codio.io/`</blockquote></p></details>

Modify the file, open it in your computer's Web browser, fill in some values in the form, and submit it.  Now go to your terminal and look at the window where `nc` is listening.  


<details><summary>How is the information you entered into the form presented to the server?  What tasks would a SaaS framework like Sinatra or Rails need to do to present this information in a convenient format to a SaaS app written in, say, Ruby? </summary><p><blockquote>The form contents are presented as a long string of the form  `key1=value1&key2=value2&...keyN=valueN` where each key is the name of a form field and the values are [URL-escaped](https://en.wikipedia.org/wiki/Percent-encoding).  The server framework must pick apart the keys and values, un-escape the  values, and present the collection in some nice way, like a hash. </blockquote></p></details>

Repeat the experiment various times to answer the following questions by observing the differences in the output printed by `nc`:

* What is the effect of adding additional URI parameters as part of the `POST` route?

* What is the effect of changing the `name` properties of the form fields?

* Can you have more than one Submit button?  If you do, how does the server tell which one was clicked?  (Hint: experiment with the attribtues of the `<submit>` tag.)

* Can the form be submitted using `GET` instead of `POST`?  If yes, what is the difference in how the server sees those requests?

* What other HTTP verbs are possible in the form submit route?  Can you get the web browser to generate a route that uses PUT, PATCH, or DELETE?

## Learning goal: understand the effect of HTTP being stateless, and the role of cookies

In this section we will use a simple app developed for this course to help you experiment with cookies.  The curious can see the [app's source code](https://github.com/saasbook/simple-cookie-demo)(it uses the simple Sinatra framework).

This app only supports two routes: 

* `GET /` returns a text string saying whether the user is logged in or not.

* `GET /login` returns a response that instructs the browser to set a cookie.  The cookie contents are set by the app to  indicate the user has logged in.  (In a real app, the server would run some code that verifies a username/password pair or similar.)

This app lives at `http://esaas-cookie-demo.herokuapp.com` but it only serves up text strings, not HTML pages.  Boring, but great for use with `curl`.


<details><summary>Try the first two <code>GET</code> operations above.  The body of the response for the first one should be "Logged in: false", and for the second one "Login cookie set."  What are the differences in the response <i>headers</i> that indicate the second operation is setting a cookie? (Hint: use <code>curl -v</code>, which will display both the request headers and the response headers and body, along with other debugging information.  <code>curl --help</code> will print voluminous help for using cURL, and <code>man curl</code> will show the Unix "manual page" for cURL on most systems.)  </summary><p><blockquote> The second operation should include in the headers <code>Set-Cookie:</code> followed by a string that is the value of the cookie to be set.  A browser would automatically grab this value and store it as one of the cookies to be sent whenever this site is re-revisisted.  (But heads up/spoiler alert: we're not using  a browser but just a simple command-line utility that issues independent HTTP requests...) </blockquote></p></details>

<details> <summary>OK, so now you are supposedly "logged in" because the server set a cookie indicating this.  Yet if you now try <code>GET /</code> again, it will still say "Logged in: false".  What's going on?  (Hint: use <code>curl -v</code>
and look at the client request headers.) </summary><p><blockquote> The server tried to set a cookie, but it's the client's job to remember the cookie and pass it back to the server as part of the headers whenever that same site is visited.   Browsers do this automaticaly (unless you have disabled cookies in the preferences), but <code>curl</code> won't do this   without explicit instructions.  The server isn't seeing the cookie as part of subsequent requests, so it can't identify you.  </blockquote></p></details>


To fix this, we have to tell `curl` to store any relevant cookies the server sends, so it knows to include them with future requests to that server.

Try `curl -i --cookie-jar cookies.txt http://esaas-cookie-demo.herokuapp.com/login` and verify that the newly created file `cookies.txt` contains information about the cookie that matches the `Set-Cookie` header from the server.  This file is how `curl` stores cookie information; browsers may do it differently.

Now we must tell `curl` to include any appropriate cookies from this file when visiting the site, which we do with the `-b` option: 

`curl -v -b cookies.txt http://esaas-cookie-demo.herokuapp.com/`

Verify that the cookie is now transmitted (hint: look at the client request headers) and the server now thinks you are logged in.

<details><summary>Looking at the <code>Set-Cookie</code> header or the contents of the <code>cookies.txt</code> file, it seems like you could have easily created this cookie and just forced the server to believe you are logged in.  In practice, how do servers avoid this insecurity?</summary><p><blockquote>In practice cookies are usually both encrypted (so the user cannot read the cookie contents, as you could here) and tamper-evident (part of the cookie is a substring that acts as a "fingerprint" for the rest of the string, so that even if you try to modify the cookie contents, you'd have to know how to also modify the fingerprint, similar to the "CVV code" used by credit cards).  The keys required for both operations are known only to the server.</blockquote></p></details>

To summarize: the only way the server can "keep track" of the same client is by setting a cookie when the client first visits, relying on the client to include that cookie in the headers on subsequent visits, and if the server modifies the cookie during the session (by including additional <code>Set-Cookie</code> headers), relying on the client to remember those changes as well.  In this way, even though HTTP itself is stateless (every request independent of every other), the app can internally maintain the notion of "session state" for each client, using the cookie as a "handle" to name that state internally. (In practice, most SaaS apps use the cookie to hold on to a lookup key that maps the cookie value to a larger and more complex data structure stored at the server.)

Disabling cookies in the client thwarts all of these behaviors, which is why most sites that require login (which is a stateful concept: you're logged in, or you're not), or which step you through a sequence of pages to do an operation (another stateful concept: which page of the flow are you currently on?  Which page should be shown next?) don't work properly if cookies are disabled in the browser.

## Test Yourself!
The following multiple choice questions can have MANY correct answers. Click on an answer's dropdown to check your understanding.

### cURL acts as a Saas _____, and netcat acts as a Saas ______.
<details><summary> client, server</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> server, client</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### What kinds of requests can you send to a server using cURL?
<details><summary> <code>GET</code></summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> <code>DISPLAY</code></summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> <code>POST</code></summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> <code>DELETE</code></summary><p><blockquote>Correct!</blockquote></p></details>

### The (Saas) server generates HTTP requests and the client sends HTTP responses.
<details><summary> True</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> False</summary><p><blockquote>Correct!</blockquote></p></details>

### HTTP ______s are received by the ______.
<details><summary> request, client</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> request, server</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> response, client</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> response, server</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### The _____ generates an HTTP _____
<details><summary> client, request</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> server, response</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> client, response</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> server, request</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### Select from the following the steps of a successful rails request-response dynamic in the correct order:
<details><summary> The browser loads the page for the user to see</summary><p><blockquote>Step 8</blockquote></p></details>
<details><summary> The Rails router (config/routes.rb) recieves the request and maps the URL to its corresponding controller and action to be handled</summary><p><blockquote>Step 2</blockquote></p></details>
<details><summary> The request is sent to the controller action, which then uses the request to ask the model to fetch data from the database</summary><p><blockquote>Step 3</blockquote></p></details>
<details><summary> A user types a URL into their browser and hits enter to send a request</summary><p><blockquote>Step 1</blockquote></p></details>
<details><summary> The controller action sends the list of data over to the view</summary><p><blockquote>Step 5</blockquote></p></details>
<details><summary> The view uses the list of data to render the page as HTML</summary><p><blockquote>Step 6</blockquote></p></details>
<details><summary> The controller returns the HTML back to the browser</summary><p><blockquote>Step 7</blockquote></p></details>
<details><summary> The models sends the requested list of data to back to the controller action</summary><p><blockquote>Step 4</blockquote></p></details>


### Which of the following statements are TRUE regarding making a request to a server using cURL vs. visiting the same URL with a browser?
<details><summary> A cURL request can be made indistinguishable from a browser request</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> cURL can only be used for technical debugging</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> Browsers can receive more information in each response compared to cURL</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> Visual styles and images cannot be shown by curl but can be seen in a browser</summary><p><blockquote>Correct!</blockquote></p></details>

### After running  `curl 'http://randomword.saasbook.info'`, you save the contents in an appropriate file and view the contents in a browser. Select all options that are TRUE about the preview that renders in the browser.
<details><summary> It contains HTML elements</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> It contains an HTTP request</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> It shows the page content of "randomword.saasbook.info"</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> It contains an HTTP response</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> There is no difference between the preview and the page on the browser</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### Assuming you run the command `nc -l 5000` on a separate window, what command can you use to make HTTP requests to this server?
<details><summary> <code>curl http://localhost:5000</code></summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> <code>curl http://127.0.0.1:5000</code></summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> <code>curl 'http://localhost:5000'</code></summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> <code>curl 'http://127.0.0.1:5000'</code></summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> <code>curl "http://localhost:5000"</code></summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> <code>curl "http://127.0.0.1:5000"</code></summary><p><blockquote>Correct!</blockquote></p></details>

### In which of the following would you see `HTTP/1.1 200 OK`?
<details><summary> In HTTP response headers</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> In HTTP request headers</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> In HTTP response body</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> In HTTP request body</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### In which of the following would you see `GET / HTTP/1.1`?
<details><summary> In HTTP response headers</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> In  HTTP request headers</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> In HTTP response body</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> In HTTP request body</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### What MAY the response headers contain?
<details><summary> The version of the HTTP protocol</summary><p><blockquote>Correct !</blockquote></p></details>
<details><summary> The server's HTTP response code</summary><p><blockquote>Correct !</blockquote></p></details>
<details><summary> Data such as descriptions of the data like the timestamp, what server is sending the response, what the content type is, and headers that could set cookies</summary><p><blockquote>Correct! These fields can be sent in headers, but are not necessary</blockquote></p></details>
<details><summary> The resource the client requested</summary><p><blockquote>Incorrect. This would be found in the response body</blockquote></p></details>
<details><summary> Status info on the error if an error occured</summary><p><blockquote>Incorrect. This would be found in the response body</blockquote></p></details>

### What MAY the response body contain?
<details><summary> The version of the HTTP protocol</summary><p><blockquote>Incorrect. This would be found in the response header</blockquote></p></details>
<details><summary> The server's HTTP response code</summary><p><blockquote>Incorrect. This would be found in the response header</blockquote></p></details>
<details><summary> Data such as descriptions of the data like the timestamp, what server is sending the response, what the content type is, and headers that could set cookies</summary><p><blockquote>Incorrect. These fields would be found in the response header</blockquote></p></details>
<details><summary> The resource the client requested</summary><p><blockquote>Correct !</blockquote></p></details>
<details><summary> Status info on the error if an error occured</summary><p><blockquote>Correct !</blockquote></p></details>

### What does <code>curl 'http://randomword.saasbook.info'</code> do and what is returned after the command is run?
<details><summary> Prints the content sent back in the server request out to the terminal.</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> Prints both the response headers then the response body out to the terminal.</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> Prints request headers, response headers, response body, and other debugging information to the terminal.</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### What does <code>curl -v 'http://randomword.saasbook.info'</code> do and what is returned after the command is run?
<details><summary> Prints the content sent back in the server request out to the terminal.</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> Prints both the response headers then the response body out to the terminal.</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> Prints request headers, response headers, response body, and other debugging information to the terminal.</summary><p><blockquote>Correct!</blockquote></p></details>

### What does <code>curl -i 'http://randomword.saasbook.info'</code> do and what is returned after the command is run?
<details><summary> Prints the content sent back in the server request out to the terminal.</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> Prints both the response headers then the response body out to the terminal.</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> Prints request headers, response headers, response body, and other debugging information to the terminal.</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### What MUST a request header contain.
<details><summary> The type of HTTP request (GET/POST/etc.)</summary><p><blockquote>Correct !</blockquote></p></details>
<details><summary> Which protocol to use</summary><p><blockquote>Correct !</blockquote></p></details>
<details><summary> Which server and port to contact</summary><p><blockquote>Correct !</blockquote></p></details>
<details><summary> Which protocol to use</summary><p><blockquote>Correct !</blockquote></p></details>
<details><summary> The path the client wants to retrieve</summary><p><blockquote>Correct !</blockquote></p></details>

### It is the _____'s job to send Set-Cookie headers.
<details><summary> Server</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> Client</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### It is the _____'s job to remember a cookie that has been sent in a Set-Cookie header.
<details><summary> Server</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> Client</summary><p><blockquote>Correct!</blockquote></p></details>

### What does it mean to say "HTTP is a stateless protocol"?
<details><summary> The server does not 'remember' any information between any two requests</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> The browser does not distinguish between any two server responses</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> The browser should not store any information from the server</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### Briefly explain why HTTP being stateless determines how cookies work. Hint: think back to your responses of the above 3 questions. Describe why the roles must be distributed the way it is. Think about what would go wrong if the responsibilities were switched between the client and server.
<details><summary> FIXME: HTTP does not store the state of user sessions, so it stores user data and uses cookies as keys so clients could simulate the user session experience without them actually being stored by the server. It is the user's job to store the cookies that the server generates and send them to the server when it makes request (if cookies are enabled). The server must process user's cookies and use them as keys to access the data that it stores for said user. If the user sends a request that should update a cookie, it is the server's responsibility to store the data tied to that request, and use the Set-Cookie header to set a cookie for the user to access the changed data that will be sent back with the server response. Since in HTTP every request is independent, it would make no sense for the server to store the cookies for a user because the server would be unable to remember a client's session between requests.</summary><p><blockquote>Correct!</blockquote></p></details>

### Disabling cookies in a browser prevents the server from generating them.
<details><summary> True</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> False</summary><p><blockquote>Correct!</blockquote></p></details>

# Which of the following are true when comparing requests sent from an incognito widow and a regular browser window under identical conditions
<details><summary> A request sent from an incognito window does not send cookies, while a regular browser can</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> The incognito window doesn't simulate session states while a regular browser does</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> Incognito mode does not save your search history but a regular browser does</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> If cookies were completely disabled, a regular browser would still save your search history</summary><p><blockquote>Correct!</blockquote></p></details>

### Briefly explain how an HTML form is submitted to a server. What happens when the submit button is clicked and what is the role of a web framework like Rails or Sinatra in handling form submissions?
<details><summary> A HTML form is sent to the server using a POST request. When the submit button is clicked, headers with information about the data is sent to the server and the server processes it and stores it if no errors occur.</summary><p><blockquote>Correct!</blockquote></p></details>

### Can an HTML form be submitted using GET instead of POST? If yes, what is the difference in how the server sees those requests? How do you control which HTTP method is invoked in an HTML form?
<details><summary> FIXME</summary><p><blockquote>Correct!</blockquote></p></details>

### 4xx errors result from _____ side issues.
<details><summary> client</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> server</summary><p><blockquote>Incorrect :(</blockquote></p></details>

### 5xx errors result from _____ side issues.
<details><summary> client</summary><p><blockquote>Incorrect :(</blockquote></p></details>
<details><summary> server</summary><p><blockquote>Correct!</blockquote></p></details>

### If the client sends a `HTTP GET` request to a non-existing URI, the response header would have the code _____.
<details><summary> 404</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> 4xx</summary><p><blockquote>Correct!</blockquote></p></details>
<details><summary> 400s</summary><p><blockquote>Correct!</blockquote></p></details>
