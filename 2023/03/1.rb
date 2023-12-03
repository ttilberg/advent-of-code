INPUT = <<~TXT
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
TXT

MOVEMENT = [-1, 0, 1].product([-1, 0, 1])

class Value
  attr_accessor :chars, :coords, :keep
  def initialize
    @coords = []
    @chars = []
    @keep = false
  end

  def value
    @chars.join.to_i
  end
end

symbols = {}
value_coords = {}
values = []

File.read('input.txt').lines.each.with_index do |line, y|
  line.chomp!

  value = Value.new
  last_char = ''

  line.chars.each.with_index do |char, x|
    if char[/[^\d.]/]
      symbols[[x, y]] = char
    end

    if char[/\d/]
      # Starting a new number
      if last_char[/\d/].nil?
        values << value if value.chars.any?
        value = Value.new
      end
      value.chars << char
      value.coords << [x, y]
      value_coords[[x, y]] = value
    end

    last_char = char
  end
  values << value if value.chars.any?
end

symbols.keys.each do |(x, y)|
  MOVEMENT.each do |(dx, dy)|
    coord = [x + dx, y + dy]
    if value = value_coords[coord]
      value.keep = true
    end
  end
end

p(values.select(&:keep).map(&:value).sum)
