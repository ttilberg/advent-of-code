sample = <<~TXT
2199943210
3987894921
9856789892
8767896789
9899965678
TXT

# board = sample.split("\n").map{|line| line.chars.map(&:to_i)}
board = File.read('input.txt').split("\n").map{|line| line.chars.map(&:to_i)}

board_x = board.first.size - 1
board_y = board.size - 1

risk_level = 0

(0..board_x).to_a.each_index do |x|
  (0..board_y).to_a.each_index do |y|
    # Even though we have a nice looking [x,y] point, the fields are flipped on the board: rows (y) come first.
    this = board[y][x]
    if this < (board[y-1]&.[](x) || 10) &&
       this < (board[y+1]&.[](x) || 10) &&
       this < (board[y]&.[](x+1) || 10) &&
       this < (board[y]&.[](x-1) || 10)
      risk_level += this + 1
    end
  end
end

puts risk_level

raise "It turns out, this solution has a board wraparound bug,
  where if it's on the boarder, it scans to the opposite side of the board.

  It passes the answer test, but I think that's by luck."
