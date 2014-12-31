require 'sinatra/base'
require 'pry'

class MyApp < Sinatra::Base

  head '/' do
    headers "You made a HEAD request" => "yup"
    ''
  end

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

  patch '/' do
    'What does PATCH even do?'
  end

  put '/' do
    'Sure, I can put that right over here.'
  end

  not_found do
    binding.pry
  end
end

run MyApp
