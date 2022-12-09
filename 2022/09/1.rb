module Coordinates
  attr_reader :x, :y
  def location = [x, y]
end

class Head
  include Coordinates
  attr_reader :tail

  def initialize
    @x = @y = 0
    @tail = Tail.new(self)
  end

  def move(direction)
    case direction
    when "R" then @x += 1
    when "L" then @x -= 1
    when "U" then @y += 1
    when "D" then @y -= 1
    end

    tail.follow
  end
end

class Tail
  include Coordinates
  attr_reader :head
  def initialize(head)
    @x = @y = 0
    @head = head
  end

  def follow
    dx = head.x - x
    dy = head.y - y
    
    if dx.abs + dy.abs > 2
      @x += dx.clamp(-1, 1)
      @y += dy.clamp(-1, 1)
    else
      @x += 1 if dx > 1
      @x -= 1 if dx < -1
      @y += 1 if dy > 1
      @y -= 1 if dy < -1
    end
  end
end

head = Head.new

map = Hash.new(0)
map[head.tail.location] += 1

File.read("input.txt").split("\n").each do |line|
  direction, n = line.split(' ')

  n.to_i.times do
    head.move(direction)
    map[head.tail.location] += 1

  end
end

p map.values.count