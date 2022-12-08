class Tree
  attr_reader :x, :y, :height
  def initialize(x, y, height)
    @x, @y = x, y
    @height = height
  end

  include Comparable
  def <=>(other)
    height <=> other.height
  end
end

class View
  attr_reader :trees, :tree
  def initialize trees, tree
    @trees = trees
    @tree = tree
    reset_view!
  end

  UP    = [ 0, -1]
  DOWN  = [ 0,  1]
  LEFT  = [-1,  0]
  RIGHT = [ 1,  0]

  def scenic_score
    [UP, DOWN, LEFT, RIGHT]
      .map{|direction| score_for(direction)}
      .reduce(&:*)
  end

  private

  def score_for(direction)
    score = 0
    reset_view!

    while next_tree = trees[@view = @view.zip(direction).map(&:sum)]
      score += 1
      break if next_tree >= tree
    end

    score
  end

  def reset_view!
    @view = [tree.x, tree.y]
  end
end


trees = {}

File.read("input.txt").lines.each_with_index do |line, y|
  line.chomp.chars.each_with_index do |tree, x|
    trees[[x, y]] = Tree.new(x, y, tree.to_i)
  end
end

high_score = 0
trees.each do |(x, y), tree|
  scenic_score = View.new(trees, tree).scenic_score
  high_score = scenic_score if scenic_score > high_score
end

p high_score
