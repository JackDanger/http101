require 'sinatra/base'

class MyApp < Sinatra::Base

  get '/' do
    "<h1>home page!</h1>"
  end

  get '/form' do
    "<form action='/name-that-cat' method='POST'>
       <input type=text name=kitty_name placeholder='a good kitty name?' />
       <input type=submit />
     </form>"
  end

  post '/' do
    "<h1>you've POSTed to '/'</h1>"
  end

  post '/name-that-cat' do
    "<h1>All hail #{params[:kitty_name]}!</h1><img src='https://placekitten.com/g/600/400' />"
  end
end


run MyApp
