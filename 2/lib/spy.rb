# \mu_2 === \mu_1^\beta mod p
# \mu_2 === (\mu^\alpha mod p )^\beta mod p
# \mu_3 = \mu_2^a mod p

class Spy
  def initialize(p, mu2, mu3)
    @p, @mu2, @mu3 = p, mu2, mu3
  end

  def a_coefficients
    @a_coefficients ||= a_raw.zip(alphas).reject{|a, alpha| alpha.nil?}.map(&:first)
  end

  def alpha
    @alpha ||= alphas.reject(&:nil?).uniq.first
  end

  def variants
    variants = []

    [*1...@p].each do |mu|
      mu1 = (mu ** alpha) % @p

      [*1...@p].each do |beta|

        if ((mu1 ** beta) % @p) == @mu2
          a_coefficients.each do |a|
            if @mu3 == ( @mu2 ** a) % @p

              b_coefficients_for(beta).each do |b|
                mu4 = (@mu3 ** b) % @p

                variants << {a: a, alpha: alpha, b: b, beta: beta, mu: mu } if mu4 == mu

              end
            end
          end
        end

      end
    end

    variants
  end

  private

  def alphas
    @alphas ||= a_raw.map { |a| [*1..@p-1].find { |i|  ((a * i) - 1) % (@p-1) == 0 } }
  end

  def a_raw
    @a_raw ||= Client::PRIMES.select { |a| @mu3 == (@mu2 ** a ) % @p }
  end

  def b_coefficients_for(beta)
    Client::PRIMES.select { |b| (b * beta) % (@p-1) == 1}
  end



end
