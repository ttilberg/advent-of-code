sample = <<~TXT
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
TXT


world = {
  sand: [],
  sand_moved: false,
  rocks: []
}

class Rock
  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end

  def coords
    [x, y]
  end
end


class Sand
  attr_accessor :x, :y
  def initialize
    @x, @y = 500, 0
  end

  def tick(world)
    solids = world[:rocks].map(&:coords) + world[:sand].map(&:coords)

    next_coords = [down, down_and_left, down_and_right].find do |coords|
      !solids.include? coords
    end

    if next_coords
      world[:sand_moved] = true
      @x, @y = next_coords if next_coords
    end
  end

  def down
    [x, y + 1]
  end

  def down_and_left
    [x - 1, y + 1]
  end

  def down_and_right
    [x + 1, y + 1]
  end

  def coords
    [x, y]
  end

end


File.read("input.txt").split("\n").each do |line|
  line.split(' -> ').each_cons(2) do |a, b|
    x, y = a.split(',').map(&:to_i)
    nx, ny = b.split(',').map(&:to_i)

    x, nx = [x, nx].sort
    y, ny = [y, ny].sort

    x.upto(nx).each do |x|
      y.upto(ny).each do |y|
        world[:rocks] << Rock.new(x, y)
      end
    end
  end
end


danger_zone = world[:rocks].map(&:y).max



tick = 0
loop do
  print "#{tick}\r" if tick % 10 == 0


  tick += 1
  world[:sand_moved] = false

  if sand = world[:sand].last
    sand.tick(world)
  end

  unless world[:sand_moved]
    world[:sand] << Sand.new
  end

  break if world[:sand].map(&:y).any? {|y| y >= danger_zone}
end


  # Map
  min_x, max_x = (world[:rocks].map(&:x) + world[:sand].map(&:x)).minmax
  min_y, max_y = (world[:rocks].map(&:y) + world[:sand].map(&:y)).minmax

  rock_map = world[:rocks].map(&:coords)
  sand_map = world[:sand].map(&:coords)
  min_y.upto(max_y).each do |y|
    min_x.upto(max_x).each do |x|
      val = '.'
      val = '#' if rock_map.include?([x, y])
      val = 'o' if sand_map.include?([x, y])
      print val
    end
    puts
  end
  puts tick

  #/Map

puts world[:sand].count - 1
