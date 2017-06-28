require 'chunky_png'
require_relative 'Texture.rb'
require_relative 'Shape.rb'

def get_division(complexity)
  # 0 a straight color
  # 1 a color with decoration
  if complexity < 2 then
    return nil
  end
  @with_ordinary = complexity > 2 ? [true, false].sample : false
  @different_children = @with_ordinary ? (Random.new.rand < complexity / 4.0) : true
  @direction = [:fess, :pale, :bend, :bend_sinister].sample
  [@with_ordinary, @different_children, @direction]
end

def get_texture(complexity, prefer_metal=false)
  # 0 a straight color
  # 1 a colour with deocration
  if complexity < 1
    return Texture.new((prefer_metal ? METALS : COLORS).sample)
  end
  Texture.new((prefer_metal ? METALS : COLORS).sample,
             (prefer_metal ? COLORS : METALS).sample,
             [nil, :cross, :crescent].sample,
             ([nil, nil, nil, nil, nil, nil, nil, nil, nil] + (prefer_metal ? COLORS : METALS)).sample)
end

def make_arms(complexity)
  s = Shape.new(:field, get_texture(complexity))
  division = get_division(complexity)
  unless division.nil?
    if division[0]
      if division[2] == :fess
        s.add_children(Shape.new([:chevron, :fess].sample, get_texture(complexity,true)))
      end
      if division[2] == :bend
        s.add_children(Shape.new(:bend,get_texture(complexity,true)))
      end
      if division[2] == :bend_sinister
        s.add_children(Shape.new(:bend_sinister, get_texture(complexity,true)))
      end
    end
    if division[1]
      halves = {
        :fess => [:top, :bottom],
        :pale => [:left, :right],
        :bend => [:bend_left, :bend_right],
        :bend_sinister => [:bend_sinister_left, :bend_siniste_right],
      }[division[2]]
      @texture1 = get_texture(complexity)
      @texture2 = get_texture(complexity)
      if @texture1.backcolor != @texture2.backcolor
        s.cover!([
          Shape.new(:field, @texture1, restriction=halves[0]),
          Shape.new(:field, @texture2, restriction=halves[1])])
      end
    end
  end
  puts s.to_s
  p s
  puts
  s
end

arms = []
for comp in 0..5
  row = []
  for i in 0..10
    row.push make_arms(comp)
  end
  arms.push row
end

tmpimg = arms[5][10].get_image
output = ChunkyPNG::Image.new((tmpimg.width)*11, (tmpimg.height+1)*6, ChunkyPNG::Color::TRANSPARENT)

for comp in 0..5
  for i in 0..10
    p "#{i*tmpimg.width} #{comp*tmpimg.height}"
    output.compose!(arms[comp][i].get_image, i*tmpimg.width, comp*tmpimg.height)
  end
end

output.save 'output.png'
