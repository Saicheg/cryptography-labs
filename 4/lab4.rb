Dir[File.expand_path('../lib/*.rb', __FILE__)].each {|f| require f}
require 'pry'
require 'colorize'
require 'matrix'

class Fixnum
  def f
    val = 1
    self.downto(2) do |k|
      val = val * k
    end
    val
  end
end

N = 4

generated = [1, Array.new(N) { rand(1..100) > 50 ? 0 : 1 }].flatten
polynom = Polynom.new(generated)#new([1,1,0,0,1])#

lsrf = Lsrf.new(polynom)

states = []

puts polynom

loop do
  states << lsrf.state
  puts lsrf.state.inspect
  lsrf.next
  break if states.include?(lsrf.state)
end

T = Array.new(2**N) { Array.new(2**N) { 0 } }

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
      (i.f / (j.f * ( i-j ).f)) % 2
    end
  end
end

t = Matrix[*T].transpose

puts "T".cyan

t.to_a.each do |arr|
  puts arr.inspect
end

c = Matrix[*C].transpose

l = c * t * c

str = 2 ** (N-1)

string = l.to_a[str].map {|i| i % 2 }

puts "L row: ".cyan

puts string.inspect

twos = Array.new(1000) {|i| 2 ** i }

sum = 0
string.each_with_index do |v, i|
  unless twos.include?(i)
    sum += v
  end
end

if sum == 0
  puts "Linear".green
else
  puts "Not linear".red
end
