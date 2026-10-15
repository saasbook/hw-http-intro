# Understand HTTP Request and Response

## Learning goal: understand basic parts of an HTTP request and response

The most basic use of `curl` is to issue an HTTP GET or POST to a site, so try `curl 'http://randomword.saasbook.info'` and verify that what you see printed could plausibly correspond to the page content you viewed in your browser previously.  (The single quotes are not technically necessary in this case, but you should get used to using them with `curl`, because URIs will often have special characters in them, such as `?` or `#`, that would be interpreted in special ways by the Unix shell if they're not protected by single quotes.)

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

<details><summary> Assuming you're running curl from another shell (on the same Codio workspace, if applicable), what URL will you have to pass to Curl to try to access your fake server, and why? </summary><p><blockquote><code>http://localhost:8081</code> is the URL.  Localhost always means "this same machine" and 8081 is the port number.  Without the port number, the default would be 80, which is the IANA default port for Web servers (or 443 for HTTPS-secured servers).  You could also use localhost's special IP address directly: <code>http://127.0.0.1:8081</code> would also work.  </blockquote></p></details>


Visit your "fake" server with curl and the correct URL.  Your "fake" server will receive the HTTP client request.

<details><summary>The first line of the request identifies which URL the client wants to retrieve.  Why don't you see <code>http://localhost:8081</code> anywhere on that line?</summary><p><blockquote>The hostname part of the URL tells the browser (or other client) which protocol to use (HTTP) and which server and port to contact (port 8081 on localhost). Once the server is contacted, the client just needs to tell it the remainder of the URL (the path portion) that it wants to retrieve.  </blockquote></p></details>


Make a note of which headers you see: this is how a real Web server perceives a connection from `curl`.

Now that you've seen what an HTTP request looks like from the server's point of view, let's see what the response looks like from the client's point of view.  In particular, `curl` just prints out the content sent back from the server, but we'd like to see the server headers.  Try `curl --help` to see the help and verify that the command line `curl -i 'http://randomword.saasbook.info'` will display BOTH  the server's response headers AND then the response body.

<details><summary> Based on the server headers, what is the server's HTTP response code giving the status of the client's request, and what version of the HTTP protocol did the server use to respond to the client?</summary><p><blockquote>The first line tells us that HTTP 1.1 was used, and that the request succeeded with code 200.</blockquote></p></details>


<details><summary> Any given Web request might return an HTML page, an image, or a number of other types of entities.  Is there anything in the headers that you think tells the client how to interpret the result? </summary><p><blockquote>The <code>Content-Type:</code> header in this case tells the client that the content returned is an HTML page.</blockquote></p></details>

---

[← Intro to HTTP and URIs](01-Intro-to-HTTP-and-URIs.md) | [Contents](README.md) | [What Happens when an HTTP request fails? →](03-What-Happens-when-an-HTTP-request-fails-.md)
