# Anything with a method '.call' can be used as a Rack server application.
# Procs (a.k.a. lambdas, a.k.a. anonymous functions) have this method.  You can
# also create your own object that responds to call:

class MyApp
  def call(env)
    [200, {}, ['hi there.']]
  end
end

run(MyApp.new)

# You can inspect the contents of the incoming request, too:
class MyApp
  def call(env)
    # `p(something)` is the same as `puts(something.inspect)`
    # This will print the contents of your HTTP request to the terminal window
    # where you started the server
    p env

    [200, {}, ['hi there.']]
  end
end
run(MyApp.new)

# Here's an example of just how simple your app *could* be:
my_app = -> (env) {
  [200, {}, ['hi there.']]
}
run(my_app)

# Or even more compact:
run(-> (*args) { [200, {}, ['hi there.']] })
# note: this is syntactically identical to:
run(lambda { |*args| [200, {}, ['hi there.']] })
# and:
run(proc { |*args| [200, {}, ['hi there.']] })
# and:
run(Proc.new { |*args| [200, {}, ['hi there.']] })
