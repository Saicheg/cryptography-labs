class Message

  attr_accessor :state
  attr_reader :content

  def initialize(p)
    @p = p
    @content = [*1...@p].sample
    @state = @content
  end

end
