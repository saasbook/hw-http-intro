# Self-Check: Question 6

In Gradescope, there is no need to create a Python file. Simply type your answer in the box.

---

### In Codio:

Create a Python script in the code editor to the left which `print()`s out the steps of a successful Rails request-response dynamic in the correct order.

**Your output should be a sequence of 8 letters separated by spaces, where the letters correspond to the steps below.**

* **A.** The browser loads the page for the user to see
* **B.** The Rails router (<code>config/routes.rb</code>) receives the request and maps the URL to its corresponding controller and action to be handled
* **C.** The request is sent to the controller action, which then uses the request to ask the model to fetch data from the database
* **D.** A user types a URL into their browser and hits enter to send a request
* **E.** The controller action sends the list of data over to the view
* **F.** The view uses the list of data to render the page as HTML
* **G.** The controller returns the HTML back to the browser
* **H.** The models sends the requested list of data to back to the controller action

> **Submission (1 point)**
>
> You should now be ready to submit your assignment. Remember to run your test cases once more, then submit your files to Gradescope, Codio or whichever platform your course is using.

---

[← Self-Check Questions 1-5](06-Self-Check-Questions-1-5.md) | [Contents](README.md) | [Self-Check Questions 7-28 →](08-Self-Check-Questions-7-28.md)
