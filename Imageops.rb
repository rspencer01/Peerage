def colourise(path, colour)
  image = ChunkyPNG::Image.from_file(path)
  for y in 0..image.height-1
    for x in 0..image.width-1
      if (image[x,y] % 256 > 200) and
        image[x,y] = colour
      else
        image[x,y] = 0
      end
    end
  end
  image
end
