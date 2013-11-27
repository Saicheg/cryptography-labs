class Lsrf
  attr_reader :state, :cycle

  def initialize(polynom)
    @polynom = polynom
    @state = Array.new(@polynom.size) { 0 }
    @state[0] = 1
    @cycle = 0
  end

  def next
    first_index = @polynom.indexes.first
    value = @state[first_index]
    i = @polynom.indexes[1..-1].inject(value) {|input, index| input ^ @state[index]}
    @state.unshift(i)
    @state.pop
    @cycle += 1
  end

  def state
    @state.dup
  end

end
