input = File.read('input.txt')

map = {}
input.lines.each.with_index do |line, y|
  line.chars.each.with_index do |char, x|
    map[[x, y]] = char if char == '@'
  end
end

COMPASS = [
  [-1, -1], [0, -1], [1, -1],
  [-1,  0],          [1,  0],
  [-1,  1], [0,  1], [1,  1],
]

map.keys.count do |(x, y)|
  COMPASS.count do |(dx, dy)|
    map[[x + dx, y + dy]]
  end < 4
end.then {p it}
