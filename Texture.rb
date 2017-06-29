METALS = [:white, :yellow]
COLORS = [:red, :black, :blue, :green]

HEXCODES = {
  :red => 0xbb1111ff,
  :blue => 0x1111bbff,
  :green => 0x11aa11ff,
  :white => 0xddddddff,
  :black => 0x000000ff,
  :yellow => 0xcccc11ff
}

NAMES =
  {
  :red => 'gules',
  :blue => 'azure',
  :green => 'vert',
  :white => 'argent',
  :black => 'sable',
  :yellow =>'or'
}

class Texture
  attr_accessor :backcolor, :charge, :erminecolor
  def initialize(backcolor, forecolor=nil, charge=nil, erminecolor=nil)
    @backcolor = backcolor;
    @forecolor = forecolor;
    @charge = charge
    @erminecolor = erminecolor
  end

  def to_s()
    if @forecolor.nil? then
      "#{NAMES[@backcolor]}"
    else
      "#{NAMES[@forecolor]} on #{NAMES[@backcolor]}"
    end
  end

  def backhexcode()
    HEXCODES[@backcolor]
  end

  def forehexcode()
    HEXCODES[@forecolor]
  end
end

#p Texture.new(:red).to_s
#p Texture.new(:red,:white).to_s
