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

# After you solve, consider looking into the x + yi style navigation?


# Start at start, try each door until we find our first room
# Track visited rooms
# When we re-enter start, divide travel time by 2.

ROOMS = {}
start = nil

File.read('input.txt').lines.each.with_index do |line, y|
  line.chars.each.with_index do |char, x|
    ROOMS[[x, y]] = char
    start = [x, y] if char == 'S'
  end
end

ROOM_MOVES["S"].each do |direction|
  destination = start.zip(direction).map(&:sum)
  from = direction.map{|coord| coord * -1}
  if !ROOM_MOVES[ROOMS[destination]].include?(from)
    ROOM_MOVES["S"].delete direction
  end
end
x
position = start
from = [0, 0]
distance = 0
loop do
  break if ROOMS[position] == 'S' && distance > 0
  p(position:, distance:)

  room = ROOMS[position]
  move = (ROOM_MOVES[room] - [from]).first
  destination = position.zip(move).map(&:sum)

  from = move.map{|coord| coord * -1}
  position = destination
  distance += 1
end

puts distance / 2