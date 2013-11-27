Dir[File.expand_path('../lib/**/*.rb', __FILE__)].each {|f| require f}
require 'rubygems'
require 'pry'
require 'colorize'

P=83#997

a = Client.new(P)
b = Client.new(P)
puts "P=#{P}"
puts "Client A params: a: #{a.secret}, \u03B1: #{a.coeff}"
puts "Client B params: b: #{b.secret}, \u03B2: #{b.coeff}"

msg = Message.new(P)
$mu = msg.state
puts "\u03BC: #{msg.state}"
a.send_message(msg)
puts "\u03BC1: #{msg.state}"
b.send_message(msg)
puts "\u03BC2: #{msg.state}"
mu2 = msg.state
a.resend_message(msg)
puts "\u03BC3: #{msg.state}"
b.resend_message(msg)
puts "\u03BC4: #{msg.state}"

if msg.state == msg.content
  puts "\u03BC4 == \u03BC".green
else
  puts "\u03BC4 != \u03BC".red
end

$beta = b.coeff

puts "*".cyan * 20
puts "Counting params".cyan
puts "*".cyan * 20

spy = Spy.new(P, mu2)

right = {a: a.secret, alpha: a.coeff, b: b.secret, beta: b.coeff, mu: msg.content}

spy.variants.each do |v|

  if v == right
    puts v.inspect.green
  else
    puts v.inspect.red
  end

end
