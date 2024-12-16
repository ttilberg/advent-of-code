class Map
  attr_reader :nodes, :node_regions, :region_nodes, :region_bumps

  def initialize(input = 'input.txt')
    # {[x, y] => 'A'}
    @nodes = {}

    # {[x, y] => 1}
    @node_regions = {}

    # {1 => Set.new([x, y])}
    @region_nodes = Hash.new{|h, k| h[k] = Set.new}

    # Track the collisions by directions as we explore the map
    # {1 => [[dx, dy, x, y], ... ]} where [dx, dy] is the direction and [x, y] is the blocked location
    #
    # The [dx, dy] are used to separate the collisions by direction, needed for the strategy I came up with.
    #
    # {1 => [[-1, 0, 2, 3], ... ]}
    #        ^-----------^ represents trying to move leftward, but being blocked at [2, 3]
    #
    @region_bumps = Hash.new{|h, k| h[k] = []}


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

  def detect_regions!
    current_region = 0

    @nodes.each do |(x, y), char|
      next if @node_regions[[x, y]]

      frontier = [[x, y]]
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
            @region_bumps[current_region] << [dx, dy, nx, ny]
          end

        end
      end

      current_region += 1
    end
  end

  # To detect walls, review the collisions that happened while exploring the map.
  # For collisions that happened while pushing left or right,
  #   take a slice of each X layer's y collision points.
  #   Do the same for pushing up and down against each slice of Y layers.
  #
  # Consider region C here:
  #  
  #   0123
  #   ||||
  # 0-AAAA
  # 1-BBCD
  # 2-BBCC
  # 3-EEEC

  # Here I've marked with `<` where collissions happened leftwards while exploring.
  #
  #   0123
  #   ||||
  # 0-AAAA
  # 1-B<CD
  # 2-B<CC
  # 3-EE<C


  # In column 1, there were leftward collisions at Y values: [1, 2].
  # This represents one wall because the values are successive.
  # In column 2, there is a single Y value: [3]. Also 1 wall, also successive
  #
  # If instead we saw [1, 2, 4, 5], that might represent a shape like:

  #   0123
  #   ||||
  # 0-AAAAF
  # 1-B<CDF
  # 2-B<CCF
  # 3-EE<CF
  # 4-E<CFF
  # 5-E<CFF
  # 6-EE<CF

  # When looking at the X = 1 dimension, there were collisions at Y values: [1, 2, 4, 5].
  # This represents two walls, since there are two sets of successive values.
  #
  # [1, 2, 4, 5]
  #  ^^^^  ^^^^
  #
  def region_walls(region)
    walls = 0

    directional_bumps = region_bumps[region].group_by {|dx, dy, x, y| [dx, dy]}
    
    # Left and Right push:
    [[-1, 0], [1, 0]].each do |direction|
      directional_bumps[direction]
        .group_by {|dx, dy, x, y| x}
        .each do |x, ys|
          these_walls = 0
          ys.map! {|dx, dy, x, y| y}
          ys.sort!

          these_walls += 1 if ys.any?
          ys.each_cons(2) do |a, b|
            these_walls += 1 if a + 1 != b
          end

          walls += these_walls
        end
    end

    # Up and Down push:
    [[0, -1], [0, 1]].each do |direction|
      directional_bumps[direction]
        .group_by {|dx, dy, x, y| y}
        .each do |y, xs|
          these_walls = 0
          xs.map! {|dx, dy, x, y| x}
          xs.sort!

          these_walls += 1 if xs.any?
          xs.each_cons(2) do |a, b|
            these_walls += 1 if a + 1 != b
          end

          walls += these_walls
        end
    end

    walls
  end
end

map = Map.new 'input.txt'
# binding.irb

map.region_nodes.sum do |region, nodes|
  nodes.count * map.region_walls(region)
end
.then {p _1}
