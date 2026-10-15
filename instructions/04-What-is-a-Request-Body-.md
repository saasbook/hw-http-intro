# What is a Request Body?

## Learning goal: understand concept of request body

Next we will create a simple HTML form that you can post from your browser and intercept it with Netcat as above, so you can see what a form posting looks like to a Web server.  This is relevant because in your own SaaS apps you will have to work with submitted form data; while most frameworks like Sinatra and Rails do a nice job for you of parsing and pre-digesting such form data in order to make it conveniently available to your app, it is worth understanding what that data normally looks like before such processing.

Once again, start `nc -l 8081` to listen on port 8081.

Create and save (ideally with extension `.html`) the following minimal file:

**Remember to replace the `FAKE-SERVER-URL-HERE` with your personal Codio box or local server URL.**

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

<details><summary>An HTML form when submitted generates an HTTP <code>POST</code> request from the browser.  In order to reach your fake server, with what URL should you replace FAKE-SERVER-URL-HERE in the above file?</summary> <p><blockquote> <b>Local computer:</b> <code>http://localhost:8081</code> <br> <b>Codio:</b> <code>https://box-name-8081.codio.io/</code> where box-name is the two-word phrase you see in your terminal prompt. Example <code>codio@emerald-tripod:~/workspace$</code> would be <code>https://emerald-tripod-8081.codio.io/</code></blockquote></p></details>


Modify the file, open it in your computer's Web browser, fill in some values in the form, and submit it.  Now go to your terminal and look at the window where `nc` is listening.  

<details><summary>How is the information you entered into the form presented to the server?  What tasks would a SaaS framework like Sinatra or Rails need to do to present this information in a convenient format to a SaaS app written in, say, Ruby? </summary><p><blockquote>The form contents are presented as a long string of the form  <code>key1=value1&key2=value2&...keyN=valueN</code> where each key is the name of a form field and the values are <a href="https://en.wikipedia.org/wiki/Percent-encoding">URL-escaped</a>.  The server framework must pick apart the keys and values, un-escape the  values, and present the collection in some nice way, like a hash. </blockquote></p></details>


Repeat the experiment various times to answer the following questions by observing the differences in the output printed by `nc`:

* What is the effect of adding additional URI parameters as part of the `POST` route?

* What is the effect of changing the `name` properties of the form fields?

* Can you have more than one Submit button?  If you do, how does the server tell which one was clicked?  (Hint: experiment with the attributes of the `<submit>` tag.)

* Can the form be submitted using `GET` instead of `POST`?  If yes, what is the difference in how the server sees those requests?

* What other HTTP verbs are possible in the form submit route?  Can you get the web browser to generate a route that uses PUT, PATCH, or DELETE?

---

[← What Happens when an HTTP request fails?](03-What-Happens-when-an-HTTP-request-fails-.md) | [Contents](README.md) | [Stateless HTTPs and Cookies →](05-Stateless-HTTPs-and-Cookies.md)
