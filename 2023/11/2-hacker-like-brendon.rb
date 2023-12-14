map = {}
File.read('input.txt').lines.each.with_index do |line, y|
  line.chars.each.with_index do |char, x|
    map[[x, y]] = true if char == '#'
  end
end

x_list, y_list = map.keys.transpose.map(&:uniq)

x_expansions = Range.new(*x_list.minmax).to_a - x_list
y_expansions = Range.new(*y_list.minmax).to_a - y_list

map.keys.combination(2).sum do |(lx, ly), (rx, ry)|
  min_x, max_x = [lx, rx].minmax
  min_y, max_y = [ly, ry].minmax
  x_expansion = x_expansions.count {|x| min_x < x && x < max_x}
  y_expansion = y_expansions.count {|y| min_y < y && y < max_y}

  (rx - lx).abs + (ry - ly).abs + (x_expansion + y_expansion) * (1_000_000 - 1)
end
  .then{|sum| p sum}
