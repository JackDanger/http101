# See more interesting examples in examples.rb

class MyApp
  def call(env)
    status_code = 200 # i.e. 'HTTP 200 OK'

    headers = {}
    headers["Content-Type"] = "text/plain"

    lines_of_body = [
      "Hi there. You're trying to retrieve the following page: ",
      env['PATH_INFO'].inspect,
      "\n",
      "With some query string parameters: ",
      env['QUERY_STRING'].inspect,
      "\n", # end with a line break character. It's just prettier.
    ]

    # Then we put it all together:
    [status_code, headers, lines_of_body]
  end
end

# Here Rack takes over for us. It'll listen on a socket and every time a
# request comes in it'll execute the `call` method on the instance of MyApp,
# passing in the current HTTP request in the form of a hash.
run MyApp.new
