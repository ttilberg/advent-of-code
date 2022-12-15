class Knot
  attr_reader :x, :y
  attr_reader :head, :tail

  def initialize(head=nil)
    @x = @y = 0
    @head = head
    @tail = nil
  end

  def attach_tail!
    @tail = Knot.new(self)
  end

  def location = [x, y]

  def move(direction)
    case direction
    when "R" then @x += 1
    when "L" then @x -= 1
    when "U" then @y += 1
    when "D" then @y -= 1
    end

    tail.follow
  end

  def follow
    dx = head.x - x
    dy = head.y - y
    
    # It has become too far away diagonally
    if dx.abs + dy.abs > 2
      @x += dx.clamp(-1, 1)
      @y += dy.clamp(-1, 1)

    # It is too far away horizontally  
    else
      @x += 1 if dx > 1
      @x -= 1 if dx < -1
      @y += 1 if dy > 1
      @y -= 1 if dy < -1
    end

    tail&.follow
  end
end

head = Knot.new
tail = 9.times.reduce(head) do |knot|
  knot.attach_tail!
end

map = Hash.new(0)
map[tail.location] += 1

File.read("input.txt").split("\n").each do |line|
  direction, n = line.split(' ')

  n.to_i.times do
    head.move(direction)
    map[tail.location] += 1
  end  
end

p map.keys.count