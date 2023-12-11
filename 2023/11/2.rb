MAP = {}
File.read('input.txt').lines.each.with_index do |line, y|
  line.chars.each.with_index do |char, x|
    MAP[[x, y]] = true if char == '#'
  end
end

x_list, y_list = MAP.keys.transpose.map(&:uniq)

MAP.keys.combination(2).sum do |(lx, ly), (rx, ry)|
  x_expansion = (Range.new(*[lx, rx].sort).to_a - x_list).count * (1_000_000 - 1)
  y_expansion = (Range.new(*[ly, ry].sort).to_a - y_list).count * (1_000_000 - 1)

  (rx - lx).abs + (ry - ly).abs + x_expansion + y_expansion
end
  .then{|sum| p sum}
