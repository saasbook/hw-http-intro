# Stateless HTTPs and Cookies

## Learning goal: understand the effect of HTTP being stateless, and the role of cookies

In this section we will use a simple app developed for this course to help you experiment with cookies.  The curious can see the [app's source code](https://github.com/saasbook/simple-cookie-demo)(it uses the simple Sinatra framework).

This app only supports two routes: 

* `GET /` returns a text string saying whether the user is logged in or not.

* `GET /login` returns a response that instructs the browser to set a cookie.  The cookie contents are set by the app to  indicate the user has logged in.  (In a real app, the server would run some code that verifies a username/password pair or similar.)

This app lives at `https://simple-cookie-demo-btbo.onrender.com` but it only serves up text strings, not HTML pages.  Boring, but great for use with `curl`.

<details><summary>Try the first two <code>GET</code> operations above.  The body of the response for the first one should be "Logged in: false", and for the second one "Login cookie set."  What are the differences in the response <i>headers</i> that indicate the second operation is setting a cookie? (Hint: use <code>curl -v</code>, which will display both the request headers and the response headers and body, along with other debugging information.  <code>curl --help</code> will print voluminous help for using cURL, and <code>man curl</code> will show the Unix "manual page" for cURL on most systems.)  </summary><p><blockquote> The second operation should include in the headers <code>Set-Cookie:</code> followed by a string that is the value of the cookie to be set.  A browser would automatically grab this value and store it as one of the cookies to be sent whenever this site is re-revisisted.  (But heads up/spoiler alert: we're not using  a browser but just a simple command-line utility that issues independent HTTP requests...) </blockquote></p></details>


<details> <summary>OK, so now you are supposedly "logged in" because the server set a cookie indicating this.  Yet if you now try <code>GET /</code> again, it will still say "Logged in: false".  What's going on?  (Hint: use <code>curl -v</code> and look at the client request headers.) </summary><p><blockquote> The server tried to set a cookie, but it's the client's job to remember the cookie and pass it back to the server as part of the headers whenever that same site is visited.   Browsers do this automaticaly (unless you have disabled cookies in the preferences), but <code>curl</code> won't do this   without explicit instructions.  The server isn't seeing the cookie as part of subsequent requests, so it can't identify you.  </blockquote></p></details>



To fix this, we have to tell `curl` to store any relevant cookies the server sends, so it knows to include them with future requests to that server.

Try `curl -i --cookie-jar cookies.txt https://simple-cookie-demo-btbo.onrender.com/login` and verify that the newly created file `cookies.txt` contains information about the cookie that matches the `Set-Cookie` header from the server.  This file is how `curl` stores cookie information; browsers may do it differently.

Now we must tell `curl` to include any appropriate cookies from this file when visiting the site, which we do with the `-b` option: 

`curl -v -b cookies.txt https://simple-cookie-demo-btbo.onrender.com/`

Verify that the cookie is now transmitted (hint: look at the client request headers) and the server now thinks you are logged in.

<details><summary>Looking at the <code>Set-Cookie</code> header or the contents of the <code>cookies.txt</code> file, it seems like you could have easily created this cookie and just forced the server to believe you are logged in.  In practice, how do servers avoid this insecurity?</summary><p><blockquote>In practice cookies are usually both encrypted (so the user cannot read the cookie contents, as you could here) and tamper-evident (part of the cookie is a substring that acts as a "fingerprint" for the rest of the string, so that even if you try to modify the cookie contents, you'd have to know how to also modify the fingerprint, similar to the "CVV code" used by credit cards).  The keys required for both operations are known only to the server.</blockquote></p></details>


To summarize: the only way the server can "keep track" of the same client is by setting a cookie when the client first visits, relying on the client to include that cookie in the headers on subsequent visits, and if the server modifies the cookie during the session (by including additional <code>Set-Cookie</code> headers), relying on the client to remember those changes as well.  In this way, even though HTTP itself is stateless (every request independent of every other), the app can internally maintain the notion of "session state" for each client, using the cookie as a "handle" to name that state internally. (In practice, most SaaS apps use the cookie to hold on to a lookup key that maps the cookie value to a larger and more complex data structure stored at the server.)

Disabling cookies in the client thwarts all of these behaviors, which is why most sites that require login (which is a stateful concept: you're logged in, or you're not), or which step you through a sequence of pages to do an operation (another stateful concept: which page of the flow are you currently on?  Which page should be shown next?) don't work properly if cookies are disabled in the browser.

---

[← What is a Request Body?](04-What-is-a-Request-Body-.md) | [Contents](README.md) | [Self-Check Questions 1-5 →](06-Self-Check-Questions-1-5.md)
