class World
  attr_reader :solids, :floor
  attr_accessor :sand, :sand_moved
  attr_reader :tick_count

  def initialize(input)
    @solids = {}
    @sand = nil
    @tick_count = 0
    @sand_moved = true

    build_world!(input)
  end

  def tick
    @tick_count += 1

    @sand ||= Sand.new
    if @sand.fall!(self)
      @sand_moved = true
    else
      @solids[@sand.coords] = :sand
      @sand = nil
      @sand_moved = false
    end
  end

  def filled_to_the_tippy_top?
    solids[[500, 0]] && !sand_moved
  end

  def sand_count
    solids.values.grep(:sand).count
  end

  def empty_at?(coords)
    x, y = coords
    return false if y == floor
    !solids[[x, y]]
  end

  def print_map!
    min_x, max_x = (solids.keys.map(&:first)).minmax
    min_y, max_y = (solids.keys.map(&:last)).minmax

    min_y.upto(max_y).each do |y|
      min_x.upto(max_x).each do |x|
        val = '.'
        val = '#' if solids[[x, y]] == :rock
        val = 'o' if solids[[x, y]] == :sand
        val = '*' if [x, y] == sand&.coords
        print val
      end
      puts
    end
    puts
  end

  private

  def build_world!(input)
    input.split("\n").each do |line|
      line.split(' -> ').each_cons(2) do |a, b|
        x, y = a.split(',').map(&:to_i)
        nx, ny = b.split(',').map(&:to_i)

        x, nx = [x, nx].sort
        y, ny = [y, ny].sort

        x.upto(nx).each do |x|
          y.upto(ny).each do |y|
            @solids[[x, y]] = :rock
          end
        end
      end
    end

    @floor = solids.keys.map(&:last).max + 2
  end
end

class Sand
  attr_accessor :x, :y
  def initialize
    @x, @y = 500, 0
  end

  def fall!(world)
    next_coords = [down, down_and_left, down_and_right].find do |next_coords|
      world.empty_at?(next_coords)
    end

    return false if next_coords.nil?
    @x, @y = next_coords
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

world = World.new(File.read("input.txt"))

until world.filled_to_the_tippy_top?
  world.tick
end

world.print_map!

puts world.sand_count
