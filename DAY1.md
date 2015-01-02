# Listening and connecting


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
