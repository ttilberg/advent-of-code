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

File.read('input.txt').lines.each.with_index do |line, y|
  line.chomp!
  total += line.scan(/\d+/).map(&:to_i).sum

  line.chars.each.with_index do |char, x|
    if char[/[^\d.]/]
      symbols[[x, y]] = char
    end

    if char[/\d/]
      numbers[[x, y]] = char
    end
  end
end

# pp(symbols:, numbers:)

symbols.keys.each do |(x, y)|
  [-1, 0, 1].product([-1, 0, 1]).each do |(dx, dy)|
    coord = [x+ dx, y+dy]
    if numbers[coord]
      # delete this
      numbers.delete(coord)

      # delete left
      offset = -1
      while numbers[[x + dx + offset, y + dy]]
        numbers.delete([x + dx + offset, y + dy])
        offset -= 1
      end

      # delete right...
      offset = 1
      while numbers[[x + dx + offset, y + dy]]
        numbers.delete([x + dx + offset, y + dy])
        offset += 1
      end
    end
  end
end

buffer = ''
sum = 0

last_x = -1
last_y = -1
numbers.each do |(x, y), value|
  if x - last_x > 1 || last_y != y
    # Flush
    sum += buffer.to_i
    buffer = ''
  end

  buffer << value
  last_x = x
  last_y = y
end

sum += buffer.to_i

p(total - sum)
