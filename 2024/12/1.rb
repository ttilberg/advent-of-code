class Map
  attr_reader :nodes, :node_regions, :region_nodes, :region_perimeters

  def initialize(input = 'input.txt')
    # {[x, y] => 'A'}
    @nodes = {}

    # {[x, y] => 1}
    @node_regions = {}

    # {1 => Set.new([x, y])}
    @region_nodes = Hash.new{|h, k| h[k] = Set.new}

    # {1 => 2}
    @region_perimeters = Hash.new(0)

    File.foreach(input).with_index do |line, y|
      line.chomp.chars.each.with_index do |char, x|
        @nodes[[x, y]] = char
      end
    end

    detect_regions!
  end

  MOVEMENT = [
    [-1,  0],
    [ 1,  0],
    [ 0, -1],
    [ 0,  1]
  ]

  # For each node, if it's not already assigned a region, scan for neighbors.
  # For each neighbor, queue exploration if it's the same region,
  #   or add to the perimeter count of this region if it was blocked.
  #
  def detect_regions!
    current_region = 0

    @nodes.each do |(x, y), char|
      next if @node_regions[[x, y]]

      frontier = [[x, y]]
      bumps = []
      until frontier.empty?
        this_x, this_y = this_node = frontier.pop

        @node_regions[this_node] = current_region
        @region_nodes[current_region] << this_node

        MOVEMENT.each do |dx, dy|
          nx, ny = this_x + dx, this_y + dy
          if @nodes[[nx, ny]] == char && @node_regions[[nx, ny]].nil?
            frontier << [nx, ny] unless frontier.include?([nx, ny])
          end

          if @nodes[[nx, ny]] != char
            bumps << [[this_x, this_y], [nx, ny]]
            @region_perimeters[current_region] += 1
          end

        end
      end

      current_region += 1
    end
  end
end

map = Map.new 'input.txt'
map.region_nodes.sum do |region, nodes|
  perimeter = map.region_perimeters[region]
  nodes.count * perimeter
end
.then {p _1}
