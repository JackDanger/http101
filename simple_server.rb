message = ARGF.gets

if /\w+:\d{4}\/home/ =~ message
  puts "200 OK :)"
else
  puts "404 :("
end
