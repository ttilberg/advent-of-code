class Tree
  attr_reader :x, :y, :height
  attr_accessor :visible
  def initialize(x, y, height)
    @x, @y = x, y
    @height = height

    @visible = false
  end

  def visible?
    visible
  end

  def inspect
    "#{x},#{y}:#{height}"
  end

  def <=>(other)
    height <=> other
  end

  include Comparable
end


trees = {}

max_x = 0
max_y = 0

File.read("input.txt").lines.each_with_index do |line, y|
  line.chomp.chars.each_with_index do |tree, x|
    trees[[x, y]] = Tree.new(x, y, tree.to_i)
    max_x = x if x > max_x
  end
  max_y = y if y > max_y
end


(0..max_x).each do |x|
  tallest_tree = -1
  (0..max_y).each do |y|
    tree = trees[[x, y]]
    if tree.height > tallest_tree
      tree.visible = true
      tallest_tree = tree.height
    end
  end

  tallest_tree = -1
  (max_y.downto(0)).each do |y|
    tree = trees[[x, y]]
    if tree.height > tallest_tree
      tree.visible = true
      tallest_tree = tree.height
    end
  end
end

(0..max_y).each do |y|
  tallest_tree = -1
  (0..max_x).each do |x|
    tree = trees[[x, y]]
    if tree.height > tallest_tree
      tree.visible = true
      tallest_tree = tree.height
    end
  end

  tallest_tree = -1
  (max_x.downto(0)).each do |x|
    tree = trees[[x, y]]
    if tree.height > tallest_tree
      tree.visible = true
      tallest_tree = tree.height
    end
  end
end

p trees.values.count(&:visible)
