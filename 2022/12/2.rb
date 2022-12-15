sample = <<~TXT
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
TXT

require "set"

class Node
  attr_reader :height, :x, :y
  attr_reader :exits
  attr_accessor :discovered_at

  def initialize(height, x, y)
    height = "a" if height == "S"
    height = "z" if height == "E"
    @height = height.ord

    @x, @y = x, y

    @exits = []
  end

  def inspect
    { height:, x:, y: }
  end

  # Add a node to potential exits.
  # Neighbors that are too high cannot be added.
  def <<(node)
    return if node.nil?
    @exits << node unless height - node.height > 1
  end
end

nodes = {}
start = nil

File
  .read("input.txt")
  .split("\n")
  .each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      nodes[[x, y]] = node = Node.new(char, x, y)
      start = node if char == "E"
    end
  end

nodes.each do |(x, y), node|
  node << nodes[[x + 1, y]]
  node << nodes[[x - 1, y]]
  node << nodes[[x, y + 1]]
  node << nodes[[x, y - 1]]
end

frontier = [start]
visit_from = {}

goal = nil
while node = frontier.shift
  if node.height == "a".ord
    goal = node
    break
  end

  node
    .exits
    .reject { |n| visit_from.keys.include? n }
    .each do |exit_node|
      visit_from[exit_node] = node
      frontier << exit_node
    end
end

path = [goal]
node = goal
while previous_node = visit_from[node]
  break if previous_node == start
  path << previous_node
  node = previous_node
end

p path.size
