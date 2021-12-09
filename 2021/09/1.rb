UPPY_DOWNY_LEFTY_RIGHTY = [[1, 0], [-1, 0], [0, 1], [0, -1]]

board = File.read('input.txt').split("\n").map.with_index do |line, y|
  line.chars.map.with_index do |char, x|
    {[x, y] => char.to_i}
  end
end.flatten.reduce(&:merge)

board.default = 10 # A number higher than 9. (For the borders.)

risk_level = 0

board.each do |(x, y), val|
  next if val == 9
  if UPPY_DOWNY_LEFTY_RIGHTY.all? {|⇦⇨, ⇧⇩| board[[x + ⇦⇨, y + ⇧⇩]] > val }
    risk_level += val + 1
  end
end

puts risk_level
