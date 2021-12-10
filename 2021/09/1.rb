UPPY_DOWNY_LEFTY_RIGHTY = [[1, 0], [-1, 0], [0, 1], [0, -1]]

board = Hash.new(10) # A number higher than 9. (For the borders.)

File.read('input.txt').split("\n").each.with_index do |line, y|
  line.chars.each.with_index do |char, x|
    board[[x, y]] = char.to_i
  end
end

risk_level = 0

board.each do |(x, y), val|
  next if val == 9
  next if UPPY_DOWNY_LEFTY_RIGHTY.any? {|⇦⇨, ⇧⇩| board[[x + ⇦⇨, y + ⇧⇩]] < val }
  risk_level += val + 1
end

puts risk_level
