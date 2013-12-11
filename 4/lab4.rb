Dir[File.expand_path('../lib/*.rb', __FILE__)].each {|f| require f}
require 'pry'
require 'colorize'
require 'matrix'

class Integer
  def fact
    (1..self).inject(:*) || 1
  end
end

def permutations from, by
  from.fact/(by.fact*((from-by).fact))
end

N = 6

generated = [1, Array.new(N-1) { [0,1].sample }, 1].flatten
#polynom = Polynom.new([1, 0, 1, 0, 0, 1, 1, 0,1])
polynom = Polynom.new(generated)

lsrf = Lsrf.new(polynom)

states = []

puts polynom

loop do
  states << lsrf.state
  puts lsrf.state.inspect
  lsrf.next
  break if states.first == lsrf.state or states.count > 2**N
end

T = Array.new(2**N) { Array.new(2**N) { 0 } }

#binding.pry

states.zip(states[1..-1]).each do |prv, nxt|
  unless nxt.nil?
    T[prv.join.to_i(2)][nxt.join.to_i(2)] = 1
  end
end
T[states.last.join.to_i(2)][states.first.join.to_i(2)] = 1

C = Array.new(2**N) do |i|
  Array.new(2**N) do |j|
    if j>i
      0
    else
      (permutations i,j) % 2
    end
  end
end

t = Matrix[*T]

puts "T".cyan

t.to_a.each do |arr|
  puts arr.join
end

c = Matrix[*C].transpose

l = c * t * c

str = 2 ** (N-1)

string = l.to_a[str].map {|i| i % 2 }

puts "L row: ".cyan

puts string.join

twos = Array.new(1000) {|i| 2 ** i }

sum = 0
string.each_with_index do |v, i|
  unless twos.include?(i)
    sum += v
  end
end

puts
puts "Polynom: #{polynom.to_s.cyan}"
if sum == 0
  puts "Linear".green
else
  puts "Not linear".red
end
