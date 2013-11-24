require 'prime'

class Client

  NUMBER_PRIME = 100

  attr_reader :secret, :coeff

  def initialize(p)
    @p = p
    count_coefficients
  end

  def count_coefficients
    begin
      @secret ||= Prime.each(NUMBER_PRIME).to_a.sample
      @coeff ||= [*1..@p-1].shuffle.select { |i| ((@secret * i) - 1) % (@p-1) == 0 }.sample
    end while @coeff.nil?
  end

  def send_message(msg)
    msg.state = (msg.state ** coeff) % @p
    msg
  end

  def resend_message(msg)
    msg.state = (msg.state ** secret) % @p
    msg
  end

end
