# \mu_2 === \mu_1^\beta mod p
# \mu_2 === (\mu^\alpha mod p )^\beta mod p
# \mu_3 = \mu_2^a mod p

class Spy
  def initialize(p, mu2)
    @p, @mu2 = p, mu2
  end

  def a_coefficients
    @a_coefficients ||= a_raw.zip(alphas).reject{|a, alpha| alpha.nil?}.map(&:first)
  end

  def alpha
    @alpha ||= alphas.reject(&:nil?).uniq.first
  end

  def variants
    variants = []

    [*1...@p-1].each do |beta|
      [*1...@p-1].each do |mu1|
        mu2 = (mu1 ** beta) % @p

        if mu2 == @mu2
          [*1...@p-1].each do |alpha|
            b_coefficients_for(beta).each do |b|
              a_coefficients_for(alpha).each do |a|

                mu3 = ((mu2 ** a) % @p)
                mu4 = ((mu3 ** b) % @p)

                if ((mu4 ** alpha) % @p) == mu1 && mu4 == $mu
                  variants << {a: a, alpha: alpha, b: b, beta: beta, mu: mu4 }
                end
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

  def a_coefficients_for(alpha)
    Client::PRIMES.select { |a| (a * alpha) % (@p-1) == 1}
  end


end
