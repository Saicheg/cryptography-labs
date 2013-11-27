require 'prime'
require 'pry'
require 'rsa'
require 'colorize'

PRIME_COUNT = 100

epsilon_1 = Prime.each(PRIME_COUNT).to_a.sample
epsilon_2 = Prime.each(PRIME_COUNT).to_a.sample
message = 0b1110011110001000.to_i

coprime_seed = 3
m = epsilon_1 * epsilon_2
alpha = Prime.each(PRIME_COUNT).to_a.sample while (alpha == nil || alpha > (m-1))
beta = (alpha ** 2) % m

def hash(signal)
  signal.split('').inject(0) do |result, n|
    result += 1 if n == "1"
    result
  end
end

def find_coprime(a, seed)
  while true
    return seed if RSA::Math.coprime?(a, seed)
    seed += 1
  end
end

mu = message.to_s(2)
s = hash(mu << beta.to_s(2)).to_s(2)

a_i = []
s.split('').count.times do |i|
  coprime_seed = find_coprime(m, coprime_seed)
  a_i << coprime_seed
  coprime_seed += 1
end

b_i = []
s.split('').count.times do |i|
  j = 0
  stop = 0
  while(stop < 1) do
    temp = (j * m + 1).to_f
    if temp % (a_i[i] ** 2) == 0
      b_i << (temp / a_i[i] ** 2).to_i
      stop += 1
    end
    j += 1
  end
end

zipped_t = a_i.zip(s.split(''))
multiplication_t = zipped_t.inject(1) { |result, e| result *= e[0] ** e[1].to_i; result }

t = alpha * multiplication_t % m

zipped_b = b_i.zip(s.split(''))
multiplication_w = zipped_b.inject(1) { |result, e| result *= e[0] ** e[1].to_i; result }
w = (t ** 2) * multiplication_w % m

puts "\u03BC: ".cyan + "#{mu}"
puts "E1: ".cyan + "#{epsilon_1}"
puts "E2: ".cyan + "#{epsilon_2}"
puts "m: ".cyan + "#{m}"
puts "\u03B1: ".cyan + "#{alpha}"
puts "\u03B2: ".cyan + "#{beta.to_s(2)}"

puts "(s, t):".cyan + "(#{s.to_i(2)}, #{t})"

puts "A: ".cyan + "#{a_i.inspect}"
puts "B: ".cyan + "#{b_i.inspect}"

puts "t: ".cyan + "#{t.to_s(2)}"
puts "w: ".cyan + "#{w.to_s(2)}"

puts "h(\u03BC, \u03B2):".cyan + "#{hash(mu.dup << beta.to_s(2))}"
puts "h(\u03BC, w): ".cyan + "#{hash(mu.dup << w.to_s(2))}"
