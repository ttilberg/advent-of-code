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
  attr_accessor :chars
  def initialize
    @chars = []
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

  last_char = ''
  value = Value.new

  line.chars.each.with_index do |char, x|
    if char == '*'
      symbols[[x, y]] = char
    end

    # Flush value buffer
    if last_char[/\d/] && char[/\d/].nil?
      values << value
      value = Value.new
    end

    # Append value buffer
    if char[/\d/]
      value.chars << char
      value_coords[[x, y]] = value
    end

    last_char = char
  end
  values << value if value.chars.any?
end

sum = 0

symbols.keys.each do |x, y|
  neighbors = MOVEMENT
    .map{|dx, dy| value_coords[[x + dx, y + dy]]}
    .compact.uniq

  if neighbors.size == 2
    sum += neighbors.map(&:value).reduce(&:*)
  end
end

p sum
# # goal: 84883664
