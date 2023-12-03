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

File.read('input.txt').lines.each.with_index do |line, y|
  line.chomp!

  value = Value.new
  last_char = ''

  line.chars.each.with_index do |char, x|
    if char == '*'
      symbols[[x, y]] = char
    end

    if char[/\d/]
      # This is a new number, flush value buffer:
      if last_char[/\d/].nil?
        value = Value.new
      end
      value.chars << char
      value_coords[[x, y]] = value
    end

    last_char = char
  end
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
