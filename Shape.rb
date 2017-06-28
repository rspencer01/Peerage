require 'chunky_png'
load 'Imageops.rb'

SHAPES = [:field]

class Shape
  attr_accessor :children
  def initialize(type, texture, restriction=nil)
    @type = type
    @children = []
    @texture = texture
    @restriction = restriction
    @covered = false
  end

  def add_children(child)
    @children = [child] + @children
  end

  def to_s()
    s = ""
    if @type == :field and not @covered
      s = "#{@texture.to_s}"
    end
    if [:bend, :bend_sinister, :fess, :chevron].include? @type
      s += "a #{@type} #{@texture.to_s}"
    end
    if @children.length>0 then
      s+= " "
      @children.each do |child|
        s += "#{child.to_s()} "
      end
    end
    s
  end

  def cover!(children)
    children.each do |child|
      add_children child
    end
    @covered = true
  end

  def get_image()
    image = colourise("#{@type}.png", @texture.backhexcode)
    if @texture.erminecolor and not @covered
      ermine_image = colourise("ermine.png", @texture.erminecolor)
      image.compose! ermine_image
    end
    y_lo = @restriction== :bottom ? image.height/2 : 0
    y_hi = @restriction== :top    ? image.height/2 : image.height-1
    x_lo = @restriction== :right ? image.width/2  : 0
    x_hi = @restriction== :left ? image.width/2  : image.width-1
    for y in 0..image.height-1
      for x in 0..image.width-1
        if  (y_lo>y) or
            (y>=y_hi) or
            (x_lo>x) or
            (x>=x_hi) or
            (@restriction == :bend_sinister_left ? x > y : false) or
            (@restriction == :bend_sinister_right ? x <= y : false) or
            (@restriction == :bend_left ? image.width-x > y : false) or
            (@restriction == :bend_right ? image.width-x <= y : false) or
            (@covered)
          image[x,y] = 0
        end
      end
    end
    if @texture.charge
      charge_image = colourise("#{@texture.charge}.png", @texture.forehexcode)
      positions = []
      scale = 0
      if @type == :field and @restriction.nil? and @children.length==0
        scale = 1
        positions = [[0,0]]
      end
      if @type == :bend
        scale = 0.3
        positions = [[(image.width*0.35).to_i,(image.height*0.3).to_i],
                     [(image.width*0.15).to_i,(image.height*0.48).to_i],
                     [(image.width*0.55).to_i,(image.height*0.12).to_i]]
      end
      if @type == :bend_sinister
        scale = 0.3
        positions = [[(image.width*0.35).to_i,(image.height*0.3).to_i],
                     [(image.width*0.15).to_i,(image.height*0.12).to_i],
                     [(image.width*0.55).to_i,(image.height*0.48).to_i]]
      end
      if @type == :fess
        scale = 0.3
        positions = [[(image.width*0.35).to_i,(image.height*0.3).to_i],
                     [(image.width*0.05).to_i,(image.height*0.3).to_i],
                     [(image.width*0.65).to_i,(image.height*0.3).to_i]]
      end
      if @type == :field and @restriction == :left
        scale = 0.45
        positions = [[(image.width*0.025).to_i,(image.height*0.25).to_i]]
      end
      if @type == :field and @restriction == :right
        scale = 0.45
        positions = [[(image.width*0.525).to_i,(image.height*0.25).to_i]]
      end
      if positions.length > 0
        charge_image.resample_bilinear!((scale*charge_image.width).to_i, (scale*charge_image.height).to_i)
        positions.each do |x,y|
          image.compose!(charge_image, x, y)
        end
      end
    end
    @children.each do |child|
      image.compose! child.get_image
    end
    image
  end
end
