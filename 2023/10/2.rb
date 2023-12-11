# Walk the pipe, and keep track of the pipe.
# Expand the resolution to be able to count the between tiles 
# as legitimate tiles by piping twice for each move.
# Then, walk the outside boundaries. It's either a "not-part-of-pipe" or a "pipe".
# Use breadth-first-search to find all connected tiles.
# Because of the expanded resolution, anything not part of pipe should
# squeeze into the nookes and crannies?

# Now, subtract the searched pieces that aren't pipe, and the pieces that are pipe
# And the placeholders, if they are still lingering.

require 'set'

# Top is Y 0, positive Y going down
ROOM_MOVES = {
  "|" => [[0, 1], [0, -1]], # is a vertical pipe connecting north and south.
  "-" => [[-1, 0], [1, 0]], # is a horizontal pipe connecting east and west.
  "L" => [[0, -1], [1, 0]], # is a 90-degree bend connecting north and east.
  "J" => [[-1, 0], [0, -1]], # is a 90-degree bend connecting north and west.
  "7" => [[-1, 0], [0, 1]], # is a 90-degree bend connecting south and west.
  "F" => [[0, 1], [1, 0]], # is a 90-degree bend connecting south and east.
  "S" => [[-1, 0], [1, 0], [0, -1], [0, 1]] # is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
}

ROOMS = {}
start = nil

# Increase the resolution by scaling x and y by 2.
# Then, when we explore, we move twice.

File.read('input.txt').lines.each.with_index do |line, y|
  y *= 2

  line.chars.each.with_index do |char, x|
    x *= 2
    # Build out rooms both for the input, and resolution scaling placeholders
    #  F * - *
    #  * * * *
    #  | * . *

    ROOMS[[x, y]] = char

    # Placeholders for increased resolutions
    ROOMS[[x + 1, y]]     = '*'
    ROOMS[[x + 1, y + 1]] = '*'
    ROOMS[[x, y + 1]]     = '*'

    start = [x, y] if char == 'S'
  end
end

# Determine first room to visit from start by finding the first neighbor
# that connects back to start
ROOM_MOVES["S"].each do |direction|
  # Account for resolution change
  scaled_direction = direction.map{|d| d * 2}
  destination = start.zip(scaled_direction).map(&:sum)
  from = direction.map{|coord| coord * -1}
  if !ROOM_MOVES[ROOMS[destination]].include?(from)
    ROOM_MOVES["S"].delete direction
  end
end

position = start
from = [0, 0]
distance = 0

# Track our pipe locations here. This will act as "visited" when
# we start to bread-first-search removal
PIPES = Set.new(start)

loop do
  break if ROOMS[position] == 'S' && distance > 0

  room = ROOMS[position]
  move = (ROOM_MOVES[room] - [from]).first

  destination = position.zip(move).map(&:sum)
  # This should put us on a resolution placeholder '*'.
  # Mark it as `pipes` and move again
  PIPES << destination

  # Move to the actual destination
  destination = destination.zip(move).map(&:sum)
  # And mark it also
  PIPES << destination

  # Hopefully we end up with connected pipes ;)
  from = move.map{|coord| coord * -1}
  position = destination
  distance += 1
end

# Walk the room perimiter, and do breadth first search to destroy cruft

(min_x, max_x), (min_y, max_y) = ROOMS.keys.transpose.map(&:minmax)

$deletions = 0
VISITED = Set.new

def infect(room)
  p(room: , deletions: $deletions)

  return if VISITED.include? room # Skip visited cells
  return if ROOMS[room].nil?      # Skip empty rooms
  return if PIPES.include?(room)  # Skip pipes

  horizon = [room]

  while this_room = horizon.shift
    VISITED << this_room
    $deletions += 1

    # infect!
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |direction|
      next_room = this_room.zip(direction).map(&:sum)
      next if VISITED.include? next_room  # Skip visited cells
      next if horizon.include? next_room  # Skip cells in queue
      next if ROOMS[next_room].nil?       # Skip empty rooms
      next if PIPES.include?(next_room)   # Skip pipes
      horizon << next_room
    end
  end
end

# top and bottom
min_x.upto(max_x).each do |x|
  infect([x, min_y])
  infect([x, max_y])
end

# left and right
min_y.upto(max_y).each do |y|
  infect([min_x, y])
  infect([max_x, y])
end

(min_y..max_y).each do |y|
  (min_x..max_x).each do |x|
    if start == [x, y]
      print '░'
    elsif PIPES.include?([x,y])
      print '█'
    elsif [min_y, max_y].include? y
      print 'o'
    elsif [min_x, max_x].include? x
      print 'o'
    elsif VISITED.include?([x, y])
      print 'v'
    elsif ROOMS[[x, y]] == '*'
      print ' '
    elsif ROOMS[[x, y]]
      print ROOMS[[x, y]]
    else
      print '?'
    end
  end
  puts
end

p (ROOMS.reject{|k, v| v == '*'}.keys - VISITED.to_a - PIPES.to_a).count
