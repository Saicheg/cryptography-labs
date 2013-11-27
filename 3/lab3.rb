# encoding: utf-8
require 'pry'
require 'colorize'
require 'active_support'
require 'active_support/core_ext/string'

origin = File.read('text.txt').gsub(/\s/, '').mb_chars.downcase.to_s.gsub(/[^абвгдежзийклмнопрстуфхцчшщъыьэюя]/, '')
File.open('in.txt', 'w+') { |f| f.puts origin }

text = File.read 'in.txt'
text = text.mb_chars.downcase.to_s
text = text.scan(/[абвгдежзийклмнопрстуфхцчшщъыьэюя]/).join

div = '01'

a = []
10.times { |l| a << (0..100).map { |i| "%0#{l}b" % i } }
a = a.flatten
a << a.flatten.map(&:reverse)
a = a.flatten.sort{|i, j| i.length <=> j.length}.uniq
a = a.map{ |s| s unless s.include?(div) }.compact

frequency = text.split('').inject({}) do |freq, char|
  freq[char] = freq[char].to_i + 1
  freq
end.sort { |(_, value1), (_, value2)| value2 <=> value1 }
puts 'Frequency: '.cyan + frequency.inspect

alph = {}
frequency.each_with_index { |fr, i| alph.merge!(fr[0] => a[i]) }
puts 'Alphabet: '.cyan + alph.inspect

enc = text.split('').map{|char| alph[char]}.join div

File.open('out.txt', 'w') {|f| f << enc }
binding.pry

dec  = enc.split div
back_alph = Hash[alph.to_a.map(&:reverse)]
puts 'Encoded alphabet: '.cyan + back_alph.inspect
dec = dec.map{|c| back_alph[c]}.join

File.open('dec.txt', 'w') {|f| f << dec }

puts "Text equvalent: ".cyan + "#{text == dec}"
puts "Original text size: ".cyan + "#{text.size*5}"
puts "Encoded text size: ".cyan +  "#{enc.size}"
puts "Compressing: ".cyan + "#{(text.size*5).to_f/enc.size.to_f }"
