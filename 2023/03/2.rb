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


# touchie thingies: Symbols

total = 0
symbols = {}
numbers = {}

last_char = ''

last_value = {
  value: '',
  coords: []
}

values = []

File.read('input.txt').lines.each.with_index do |line, y|
  line.chomp!
  total += line.scan(/\d+/).map(&:to_i).sum

  line.chars.each.with_index do |char, x|
    if char == '*'
      symbols[[x, y]] = char
    end

    if last_char[/\d/] && char[/\d/].nil?
      values << last_value

      last_value = {
        value: '',
        coords: []
      }
    end

    if char[/\d/]
      last_value[:value] << char
      last_value[:coords] << [x,y]
    end

    last_char = char
  end
end

values.each do |v|
  v[:value] = v[:value].to_i
end

p(values:)
sum = 0

symbols.keys.each do |x, y|
  # For each sprocket thingy...
  touching_fellas = values.select do |value|
    [-1, 0, 1].product([-1, 0, 1]).any? {|dx, dy| value[:coords].include?([x + dx, y + dy])}
  end

  if touching_fellas.size == 2
    sum += touching_fellas.map{|fella| fella[:value]}.reduce(&:*)
  end
end


# symbols.keys.each do |(x, y)|
#   [-1, 0, 1].product([-1, 0, 1]).each do |(dx, dy)|
#     coord = [x+ dx, y+dy]
#     if numbers[coord]
#       puts "Entering delete mode at #{coord}}"
#       # delete left, delete right...

#       numbers.delete(coord)

#       offset = -1
#       while numbers[[x + dx + offset, y + dy]]
#         numbers.delete([x + dx + offset, y + dy])
#         offset -= 1
#       end

#       # delete right...
#       offset = 1
#       while numbers[[x + dx + offset, y + dy]]
#         numbers.delete([x + dx + offset, y + dy])
#         offset += 1
#       end
#     end
#   end
# end

# p(numbers:)
# bad_guys = ''
# sum = 0

# last_x = -1
# last_y = -1
# numbers.each do |(x, y), value|
#   if x - last_x > 1 || last_y != y
#     puts "Flushing"
#     sum += bad_guys.to_i
#     bad_guys = ''
#   end

#   bad_guys << value
#   last_x = x
#   last_y = y
#   p(x:, y:, value: )
#   p(bad_guys:)
# end

# sum += bad_guys.to_i

# p(total - sum)

p sum
# # goal: 467835
