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

```
nc motherfuckingwebsite.com 80
GET / HTTP/1.1
Host: motherfuckingwebsite.com

```

What just happened?

The program `nc` (an abbreviation of "netcat" or "network concatenate")
connected to the computer known as motherfuckingwebsite.com on port 80.
Then it wrote two lines of plain text into that connection. Luckily,
there was a web server program listening on that port that knew how to
speak HTTP and it properly understood our request.



Challenges:
1. Make `nc` continue listening on a port even after you've connected to
   it and subsequently disconnected from it. (hint: you can run any
program in an infinite loop via `while true; do my_command; done`
1. Try to listen to port 400 on your local machine? What happens? What's
   the port number where you start getting a different response?
1. Try to listen to the same port with two programs at the same time.
   What happens?
1. Listen on a port in such a way that all of the data sent to that port
   gets redirected to a file. (hint: you're going to need to do the
normal listen command and then use the '>' character afterward for
sending the programs "standard output" to a file.)
1. Connect to a port that you're listening on and send the contents of a file into that port. Try to get those file contents to display in the terminal that is listening on that port.

# HTTP requests and responses

### Be an HTTP client

First, let's be an HTTP client. We're going to retrieve
[http://motherfuckingwebsite.com] and display its contents to our
screen. We're basically going to turn ourselves into a really, really
user-unfriendly web browser. Type the following into your terminal:

```bash
nc motherfuckingwebsite.com 80
GET / HTTP/1.1
Host: motherfuckingwebsite.com

```

Hit enter a couple times at the end if nothing happens. What you see
should be the HTML source of [http://motherfuckingwebsite.com].

What you just did is all that a web browser does, though browsers also
do the work of rendering the HTML properly on your screen. Had you
copied the HTML that the server sent you into a file and opened it in a
modern document editor it would render to your screen just like in a
browser.


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
