# Listening and connecting

HTTP relies on a relationship between clients and servers. A server is
something that has a resource and a client is something that wants that
resource. For HTTP this means a server has a web page (or image or
javascript file, etc.) and the client (typically a browser) wants to
retrieve these files.

In order for the server to be of any use it needs to make itself
available to clients somehow even before any client attempts to make a
reqeust. An HTTP server does this by "listening" on a specific port of a
computer (typically port 80 for unsecured pages, port 443 for HTTPS) and
waiting for a client to connect and make a request.

A super long time ago (long before HTTP) the way this worked was there
would be a computer configured such that any electrical signals on a
port (literally a plug in the side of the computer) would be sent as
inputs to some program or function. This is a server. The only
difference between that archaic model and what we have today is that the
port is more of a metaphor and your computer's network card can let you
pick thousands of arbitrary port numbers to listen on and clients can
pick which one they connect to.

In this lesson we'll explore how any Unix-like OS (Linux, Mac, BSD,
etc.) allows programs to act as HTTP servers and clients.

### Connecting

First, we're going to try to connect to a computer on a specific port
number.

Run this in one terminal window:
```
nc -l localhost 5050
```

And then run this in a second window:
```
nc localhost 5050
```

Type "hi" into that second window. Notice that what you type is sent
to "localhost" (your computer) right into the port that you're listening
on in the first window.

Anything you type will keep being sent over the network from the client
(the second window that you're typing into) to the server (the first
window where your program is listening on the port).

Let's try doing that again but lets send over some data that's been
prepared in advance. CTRL-C both of your `nc` instances and type the
following to create a new text file:

```
cat > badjoke
Deja Moo: The feeling that you've heard this bull before.
```
When you're done don't type `CTRL-C`, type `CTRL-D` instead. That's the
Unix way of sending a character that says "I'm all done now!" It's a
great way to exit your terminals or signal you're finished typing
without necessarily trying to kill a program.

Now that we have that file with a line of plaintext in it let's send it
over the network from one terminal to another.

In one terminal set up the server with `nc -l localhost 5050` just like
before.

And in the other window make sure the file has some data in it:

```
cat badjoke
```

Yup. That's a bad joke. Now let's "concatenate" it via netcat (`nc`) over
the network:

```
cat badjoke | nc localhost 5050
```

Notice that vertical pipe character? That means instead of printing the
output of the previous command on the screen use it as if it were typed
as the input of the next command. Basically you just avoided having to
hand-type the joke any time you want to send it somewhere.

Challenges:

1. Make `nc` continue listening on a port even after you've connected to
   it and subsequently disconnected from it. (hint: you can run any
program in an infinite loop via `while true; do my_command; done`
1. Try to listen to port 400 on your local machine? What happens? What's
   the port number where you start getting a different response?
1. Listen on a port in such a way that all of the data sent to that port
   gets redirected to a file. (hint: you're going to need to do the
normal listen command and then use the '>' character afterward for
sending the programs "standard output" to a file.)
1. Depending on the networking setup where you are see if you can listen
   as a server on one computer and connect as a client from another.

# HTTP requests and responses

### Be an HTTP client

First, let's be an HTTP client. We're going to retrieve
[http://motherfuckingwebsite.com](http://motherfuckingwebsite.com) and display its contents to our
screen. We're basically going to turn ourselves into a really, really
user-unfriendly web browser. Type the following into your terminal:

```bash
nc motherfuckingwebsite.com 80
GET / HTTP/1.1
Host: motherfuckingwebsite.com

```

Hit enter a couple times at the end if nothing happens. What you see
should be the HTML source of
[http://motherfuckingwebsite.com](http://motherfuckingwebsite.com)

What you just did is all that a web browser does, though browsers also
do the work of rendering the HTML properly on your screen. Had you
copied the HTML that the server sent you into a file and opened it in a
modern document editor it would render to your screen just like in a
browser.

### Be a bad HTTP client

Let's do that again but send some gibberish.

```
nc motherfuckingwebsite.com 80
GET / I DUNNO
stuff, man

```

You should see a response that looks something like the following:

```
HTTP/1.1 400 Bad Request
Date: Thu, 29 Jan 2015 01:34:08 GMT
[...]
<h1>Bad Request</h1>
<p>Your browser sent a request that this server could not understand.<br
/>
Request header field is missing ':' separator.<br />
<pre>
stuff, man</pre>
```

The HTTP server (whatever program was listening on the other side) knows
how to look at the lines you're typing and parse out good requests from
bad. Netcat, the simple little tool that it is, when it acts as a server
using the `-l` flag doesn't bother parsing anything - it just spits
whatever you send it right out onto the screen.


### Be an HTTP server

Now shit's gonna get real. We're going to implement a complete HTTP
server. Sorta. You were able to hand-type the HTTP client stuff so why
not do the same on the other end?

First, let's save the results of an HTTP request to
[http://motherfuckingwebsite.com](http://motherfuckingwebsite.com) to a
file:

```
nc motherfuckingwebsite.com 80 > http_response
GET / HTTP/1.1
Host: motherfuckingwebsite.com

```

Remember to hit the enter key a bunch at the end.

Let's check that that file has what we think it does:
```bash
cat http_response
```

Should produce something like:
```
HTTP/1.1 200 OK
Date: Thu, 29 Jan 2015 01:58:46 GMT
Server: Apache
Last-Modified: Sun, 18 Jan 2015 00:04:33 GMT
Accept-Ranges: bytes
Content-Length: 5108
Vary: Accept-Encoding
Content-Type: text/html

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
[...]
```

Yup, golden. It's not only the 

Challenges:

1. Connect to http://motherfuckingwebsite.com and save just the http headers to a file (hint: you’ll want to use either the program `split` or `head`)
1. Connect to an HTTPS website using `openssl s_client` (hint: you may need to read `openssl s_client -h` and/or Google for a solution)
1. Try the above challenges using `curl` instead of `nc`. How goddamned
   much easier is this? Try an HTTPS website with curl, too.
1. Run curl with the command line option that prints out only the HTTP
   response headers, not the response body itself

# The Rack interface
Challenges:

1. Make a server that listens on port 2000 and another that listens on
   port 3000 in the same Ruby file. Connect to them both with curl.
1. Make a server that creates an HTTP response somehow customized to the
   HTTP request (hint: check env['PATH_INFO'] for a value that's easily customizable via `curl`)
1. Refactor your Ruby code to be way less ugly. Name things well.
1. See what happens when you provide the wrong kinds of data to the rack
   response. A string for the final argument? How about an integer? What
if you have a blank HTTP header hash? What if you use an invalid status
code?

# Sinatra
Challenges:

1. Create an app that shows different content when you GET to it versus
   POST to it.
1. Create a form that displays in the browser and POSTs somewhere.
   Display data on the resulting page based on what you typed into the
form.
1. Use `binding.pry` to stop execution during a request and inspect data
   like 'env', 'params', etc. (hint: don't forget to `require 'pry'`
somewhere. Use CTRL-D to exit pry.)
1. Create separate blocks that execute for each of the following HTTP
   verbs: HEAD, GET, POST, PUT, PATCH. (hint: you'll need to add `-d ''`
to the end of your curl request for some of these. Also, you'll need to
put the `head()` definition before your `get()` definition).

# The Rails request cycle

```bash
rails new rails_app
cd rails_app
rails generate controller home
rails server
```

Add Pry to the Gemfile for debugging:
```bash
echo "gem 'pry-byebug', require: true" >> Gemfile
bundle
```

Make `app/controllers/home_controller.rb` look like this:
```ruby
class HomeController < ApplicationController

  # This line let you use `curl` without worrying about security stuff
  skip_before_filter :verify_authenticity_token

  def gerbils
    render :text => 'Gerbils!'
  end

  def penguins
    render :text => 'Penguins!'
  end
end
```

in `config/routes.rb`
```ruby
  get '/' => 'home#gerbils'
  post '/' => 'home#penguins'
```

Challenges:
1. Use `binding.pry` to inspect the environment of a Rails request
   inside the `gerbils` or `penguins` method. What's the difference
   between `request.env` and the old Rack `env`? Check out the `request`
   and `response`
1. Look inside the `request` object to find out information about the
   client making the HTTP request. What's the user agent (i.e. browser)?
   What's the ip address that this HTTP request is coming from (and will be
   sent back to)?
1. What other HTTP verbs can you get Rails to support? (hint: google
   "http verbs" and you'll find a list with a technical description of
   how they should be used.)
