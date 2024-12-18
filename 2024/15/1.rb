class LanternfishWarehouse
  DIRECTIONS = {
    "<" => [-1,  0],
    ">" => [ 1,  0],
    "^" => [ 0, -1],
    "v" => [ 0,  1],
  }

  LEGEND = {
    "@" => :fella,
    "O" => :box,
    "#" => :wall,
  }

  attr_reader :fella, :map, :directions, :frame

  def initialize(filename = 'input.txt')
    map, directions = File.read('input.txt').split("\n\n")

    @fella = nil
    @map = {}

    @width = 0
    @height = 0

    map.each_line.with_index do |line, y|
      @height = y if y > @height
      line.chomp.chars.each.with_index do |char, x|
        @width = x if x > @width

        tile = LEGEND[char]
        next if tile.nil?

        if tile == :fella
          @fella = [x, y]
        else
          @map[[x, y]] = tile
        end
      end
    end

    @directions = directions.chars.map{|char| DIRECTIONS[char]}.compact

    @frame = 0
  end

  REVERSE_LEGEND = LEGEND.invert

  def overview
    (@height + 1).times do |y|
      (@width + 1).times do |x|
        char = REVERSE_LEGEND[@map[[x, y]]]
        char = '@' if [x, y] == @fella
        print char || ' '
      end
      print $/
    end
    print $/ * 2
  end


  def run
    time = 0
    directions.each do |dx, dy|
      time += 1
      # overview
      # p(time:, direction: DIRECTIONS.invert[[dx, dy]])

      # gets
      x, y = @fella

      nx = x + dx
      ny = y + dy

      # Free move
      if @map[[nx, ny]].nil?
        @fella = [nx, ny]
        next
      end

      # Wally move
      if @map[[nx, ny]] == :wall
        next
      end

      # Complicated move
      boxes = []
      until @map[[nx, ny]] == :wall || @map[[nx, ny]].nil?
        boxes << [nx, ny]
        nx += dx
        ny += dy
      end

      # Can't move
      if @map[[nx, ny]] == :wall
        next
      end

      
      box_x, box_y = box = boxes.first
      @map.delete box
      @map[[
        box_x + dx * boxes.size,
        box_y + dy * boxes.size
      ]] = :box

      @fella = [x + dx, y + dy]
    end

    self
  end

  def gps_score
    @map.select{|location, tile| tile == :box}
      .map{|(x, y), tile| y * 100 + x}
      .sum
  end
end

LanternfishWarehouse.new
  .run
  .gps_score
  .then {p _1}

