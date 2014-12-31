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
      env.inspect,
      "\n", # end with a line break character. It's just prettier.
    ]

    [status_code, headers, lines_of_body]
  end
end

run MyApp.new
