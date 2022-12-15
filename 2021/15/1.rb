require 'pry'

class Node
  attr_accessor :to
  attr_reader :level
  attr_accessor :hp

  def initialize(x, y, level)
    @x, @y = x, y
    @level = @hp = level.to_i
    @to = []
  end

  def inspect
    "<Node #{coords} level: #{level}, hp: #{hp}, to: #{to.size}>"
  end

  def <<(val)
    return if val.nil?
    @to << val
  end

  def coords
    [@x, @y]
  end
end


nodes = {}

max_x = max_y = 0

File.read("input.txt").split.each.with_index do |line, y|
  line.chars.each.with_index do |char, x|
    nodes[[x, y]] = Node.new(x, y, char.to_i)
    max_x = x if x > max_x
  end
  max_y = y if y > max_y
end

# Assign exits to each node
nodes.each do |(x, y), node|
  [
    nodes[[x, y + 1]],
    nodes[[x, y - 1]],
    nodes[[x + 1, y]],
    nodes[[x - 1, y]]
  ].compact.each do |buddy|
    node << buddy
  end
end

start = nodes[[0,0]]
goal = nodes[[max_x, max_y]]

frontier = [start]

came_from = {}
came_from[start] = nil

# I had to look up the nature of "breadth-first" searching
# I also saw that there are two variations called:
#  - dyjkstra: Account for "difficulty" to traverse
#  - A* : Add a sense of goal
#
# After understanding how breadth-first searching works
# and realizing that a value of 2 is no different
# than having to move 2x 1 tiles, I thought
# I'd leverage the notion of hit points for each block.
#
# I didn't actually look up dyjkstra yet, but I assume
# it works something like this, where a given node
# has a condition to wear down, and get back in line.
#
# This seems to work!

while node = frontier.shift
  if (node.hp -= 1) > 0
    frontier << node
    next
  end

  node.to.reject{|n| came_from[n]}.each do |buddy|
    came_from[buddy] = node
    frontier << buddy
  end
end

path = [goal]

node = goal
until node == start
  path << node = came_from[node]
end


min_x, max_x = came_from.keys.map(&:coords).map(&:first).minmax
min_y, max_y = came_from.keys.map(&:coords).map(&:last).minmax

coords_from = came_from.transform_keys(&:coords).transform_values(&:coords)

min_y.upto(max_y).each do |y|
  min_x.upto(max_x).each do |x|
    from_x, from_y = coords_from[[x, y]]

    val = '•'
    if path.include?(nodes[[x ,y]])
      val = '◀' if from_x < x
      val = '▶' if from_x > x
      val = '▲' if from_y < y
      val = '▼' if from_y > y
      val = '§' if x == 0 && y == 0
    end

    print val
  end
  puts
end

*everywhere_else, start = path
p part_1: everywhere_else.map(&:level).sum
