class Room
  attr_reader :x, :y

  def initialize(x:, y:)
    @x, @y = x, y
  end

  def location()  = [x,     y    ]
  def up()        = [x,     y - 1]
  def down()      = [x,     y + 1]
  def left()      = [x - 1, y    ]
  def right()     = [x + 1, y    ]
  def neighbors() = [up, left, down, right]
end

class World
  attr_reader :rooms
  attr_reader :big_beefy_basins

  # Parse the input board, essentially delimiting rooms by '9'.
  # A "basin" is anything that isn't a 9.
  # If we build a hash of "things not 9" we can explore it.
  # We can also delete rooms in realtime so they don't get
  # "re-explored" which is kind of neat.
  #
  # For easy exploration, we'll use the `[x,y]` coords as hash keys.
  #
  def initialize(board)
    @rooms = {}

    board.split("\n").each.with_index do |line, y|
      line.chars.each.with_index do |val, x|
        rooms[[x, y]] = Room.new(x: x, y: y) if val != '9'
      end
    end

    @big_beefy_basins = Array.new(3) { 0 }
  end

  def solve!
    rooms.each do |(x, y), room|
      basin = explore(room).uniq.size

      if big_beefy_basins.first < basin
        big_beefy_basins.shift
        big_beefy_basins.push(basin).sort!
      end
    end

    big_beefy_basins.reduce(&:*)
  end

  private

  def explore(room, basin=[])
    return basin if room.nil?

    basin << rooms.delete(room.location)

    room.neighbors

    room.neighbors.map do |x, y|
      explore(rooms[[x, y]], basin)
    end.flatten
  end
end

pp World.new(File.read('input.txt')).solve!
