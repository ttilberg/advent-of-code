class Guy
  attr_accessor :x, :y, :facing, :visited

  MOVEMENT = [
    [ 0, -1],   # up
    [ 1,  0],   # right
    [ 0,  1],   # down
    [-1,  0],   # left
  ]

  def initialize
    @x, @y = nil, nil
    @facing = 0

    @visited = Set.new
  end

  def visit(x, y)
    @x, @y = x, y
    @visited << [x, y]
  end

  def location
    [x, y]
  end

  def next_move
    dx, dy = MOVEMENT[facing]
    [x + dx, y + dy]
  end

  def next_x
    next_move[0]
  end
  
  def next_y
    next_move[1]
  end

  def move!
    visit(*next_move)
  end


  def turn!
    @facing = (@facing + 1) % MOVEMENT.size
  end
end

guy = Guy.new
obstacles = {}
width, height = 0, 0

File.foreach('input.txt').with_index do |line, y|
  height = y if y > height
  line.chars.each.with_index do |char, x|
    width = x if x > width

    case char
    when '#'
      obstacles[[x, y]] = '#'
    when '^'
      guy.visit(x, y)
    end
  end
end

loop do
  if obstacles[guy.next_move].nil?
    if (0...width).cover?(guy.next_x) && (0...height).cover?(guy.next_y)
      guy.move!
    else
      break
    end
  else
    guy.turn!
  end
end

puts guy.visited.count

