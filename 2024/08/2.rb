class Map
  SIGNAL = /[a-zA-Z0-9]/

  attr_reader :width, :height, :signals, :anti_nodes

  def initialize(input = File.read('input.txt'))
    @width = 0
    @height = 0

    # {'A' => [x, y], ...}
    @signals = Hash.new {|h, k| h[k] = []}

    @anti_nodes = Set.new

    input.lines.each.with_index do |line, y|
      line.chomp.chars.each.with_index do |char, x|
        @width = x if x > @width
        @height = y if y > @height

        if char.match?(SIGNAL)
          @signals[char] << [x, y]
        end
      end
    end

    # Detect anti-nodes
    @signals.each do |signal, locations|
      locations.combination(2).each do |(x1, y1), (x2, y2)|
        dx = x2 - x1
        dy = y2 - y1

        # Left Expansion:
        i = 0
        loop do
          x = x1 - dx * i
          y = y1 - dy * i
          break if off_map?(x, y)
          @anti_nodes << [x, y]
          i += 1
        end

        # Right expansion:
        i = 0
        loop do
          x = x2 + dx * i
          y = y2 + dy * i
          break if off_map?(x, y)
          @anti_nodes << [x, y]
          i += 1
        end
      end
    end
  end

  def on_map?(x, y)
    (0..width).cover?(x) && (0..height).cover?(y)
  end

  def off_map?(x, y)
    !on_map?(x, y)
  end

end

map = Map.new

puts map.anti_nodes.count
