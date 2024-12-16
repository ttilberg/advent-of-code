# Often times I'll take a functional approach
# chaining a bunch of map, filter, sum, etc.
# But for "simulation" type problems, I really enjoy getting classy.
#
# It just helps model "what needs to be done".

# The Guy helps keep track of his position and where he's visited.
#
class Guy
  attr_accessor :x, :y, :facing, :visited

  # These vectors help calculate the next position.
  #   Originally I had a hash of {up: [..], right: [..]}
  #     but I changed to an array to assist with turning.
  #   This let me just keep a "facing" index int that I can modulo to cycle
  #     rather than an :up symbol and needing to separately keep track of "the next one".
  #
  MOVEMENT = [
    [ 0, -1],   # up
    [ 1,  0],   # right
    [ 0,  1],   # down
    [-1,  0],   # left
  ]

  def initialize(x, y)
    @x, @y = x, y
    @facing = 0

    @visited = Set.new
    visit(x, y)
  end

  # `move!` is the intended public usage of "you go boi".
  # It automates visiting to the next position.
  def move!
    visit(*next_location)
  end

  # By tracking direction as an int, we can cycle through the MOVEMENT.size.
  def turn!
    @facing = (@facing + 1) % MOVEMENT.size
  end

  def visit(x, y)
    @x, @y = x, y
    @visited << [x, y]
  end

  def location
    [x, y]
  end

  def next_location
    dx, dy = MOVEMENT[facing]
    [x + dx, y + dy]
  end

  # Easily making helper methods like this is why I like OO for simulation work.
  # It's just easier to create utilities for.
  def next_x
    next_location[0]
  end
  
  def next_y
    next_location[1]
  end
end


# The Map parses the puzzle input and keeps track of:
#   - Start position so we can:
#     - Start multiple dudes in the right spot
#     - Remove this location from blockade testing
#   - Size of the map to easily determine if we've exited
#   - Obstacles as a Hash for fast querying
# 
class Map
  attr_reader :obstacles, :width, :height, :entrance

  def initialize(input_file = 'input.txt')
    @entrance = nil
    @obstacles = {}
    @width, @height = 0, 0

    File.foreach(input_file).with_index do |line, y|
      @height = y if y > @height
      line.chars.each.with_index do |char, x|
        @width = x if x > @width

        case char
        when '#'
          @obstacles[[x, y]] = char
        when '^'
          @entrance = [x, y]
        end
      end
    end
  end

  # Is there a `#` in the queried location?
  def blocked?(x, y)
    obstacles[[x, y]]
  end

  # Is the queried location even valid?
  def on_map?(x, y)
    (0..width).cover?(x) && (0..height).cover?(y)
  end
end

# My primary strategy was a nice extension of pt 1.
# First, run the maze to build a list of visited locations, as in pt 1.
#
# Then, for each visited location, we'll run the simulation again with a fresh guy
# We'll add an extra blocker at that visited location while checking for looping.
#


# First, the base sim to get the base path. This was the same as pt 1.
map = Map.new
guy = Guy.new(*map.entrance)

while map.on_map?(*guy.next_location)
  if map.blocked?(*guy.next_location)
    guy.turn!
    next
  end

  guy.move!
end


# We need a tool to check for loops. An easy way to check:
# "have I been in this location facing this direction.
# So we'll keep a unique set of `[x, y, facing]`
#
class Route
  def initialize
    @visited = Set.new
    @looping = false
  end

  # Is the requested position new?
  # Cool ruby trick: `Set#add?`. Adds the data to the set, and return true/false if it's new/exist 
  def fresh_move?(x, y, direction)
    @visited.add? [x, y, direction]
  end
end

loops = 0

# For each location along the OG path:
(guy.visited - Set.new([map.entrance])).each.with_index do |to_visit, i|
  # Make a fresh dude to run
  dude = Guy.new(*map.entrance)
  # I suppose this could have been in the Guy class.
  route = Route.new

  # Mostly copy pasted from pt 1...
  while map.on_map?(*dude.next_location)
    # But with an extra "block" when the next location is the one we're testing
    #                                    vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    if map.blocked?(*dude.next_location) || to_visit == dude.next_location
      dude.turn!
      next
    end
    # Also, now we need to keep track of our looping
    if route.fresh_move?(*dude.next_location, dude.facing)
      dude.move!
    else
      loops +=1
      break
    end
  end
end

puts
puts loops
