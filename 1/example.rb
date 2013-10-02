# encoding: UTF-8

require 'rubygems'
require 'pry'

class Decoder
  def message
    @message ||= "111 101 101 001 101 111 101 000 110 111 111 101 100 001 000".reverse
  end

  def split_message(message, word_length = 5)
    words = message.split(' ')
    words.join('').scan(/(\d{15})/).flatten
  end

  def dictionary
    @dictionary ||= %w{армия мицар мария тарту рация марта марат тиара}
  end

  def default_alphabet
    @default_alphabet ||= ["м","и","ц","а","р","я","т","у"]
  end

  def nums
    @nums ||= (0...8).to_a.map{|n| "%03d" % n.to_s(2)}
  end

  def encoded_alphabet(alphabet)
    Hash[alphabet.zip(nums)]
  end

  def decoded_alphabet(alphabet)
    Hash[nums.zip(alphabet)]
  end

  def encoded_alphabets
    @en_alphabets ||= default_alphabet.permutation.to_a.inject([]) do |result, alph|
      result << encoded_alphabet(alph)
      result
    end
  end

  def decoded_alphabets
    @dec_alphabets ||= encoded_alphabets.inject([]) do |result, alph|
      result << alph.invert
      result
    end
  end

  def encoded_dictionary(alphabet)
    dictionary.inject([]) do |result, word|
      result << encode_word(word, alphabet)
      result
    end
  end

  def encode_word(word, alphabet)
    result = word.dup
    alphabet.each do |k, v|
      result.gsub!(k, v)
    end
    result
  end

  def decode_word(word, alphabet)
    word.scan(/(\d{3})/).flatten.inject("") do |result, code|
      result << alphabet[code]
      result
    end
  end

  def xor_strings(first, second)
    result = (first.to_i(2) ^ second.to_i(2))
    "%015d" % result.to_s(2)
  end

  def perform
    decoded = []
    msg = split_message(message)
    encoded_alphabets.each do |alphabet|
      inv_alphabet = alphabet.invert
      encoded_dict = encoded_dictionary(alphabet)
      noises = encoded_dict.inject([]) do |result, word|
        result << xor_strings(msg[0], word)
        result
      end

      exit_flag = false
      noises.each do |noise|
        ret1 = decode_word(xor_strings(msg[1], noise), inv_alphabet)
        decoded << ret1
        if dictionary.include?(ret1)
          ret2 = decode_word(xor_strings(msg[2], noise), inv_alphabet)
          if dictionary.include?(ret2)
            ret0 = decode_word(xor_strings(msg[0], noise), inv_alphabet)
            puts("ALPHABET: " + inv_alphabet.inspect)
            puts("MESSAGE: " + msg.inspect)
            puts("NOISE: " + noise.inspect)
            puts("DECODED MESSAGE: #{ret0} #{ret1} #{ret2}" )
            exit_flag = true
          end
        end
        if exit_flag
          return
        end
      end
    end
    decoded = decoded.uniq
  end
end


decoder = Decoder.new
decoder.perform

