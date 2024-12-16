map = File.read('input.txt').lines.map(&:chars)

WIDTH = map.first.size
HEIGHT = map.size

XMAS = 'XMAS'

vectors = [
  [-1, -1], [-1, 0], [-1, 1],
  [ 0, -1],          [ 0, 1],
  [ 1, -1], [ 1, 0], [ 1, 1],
]

count = 0

HEIGHT.times do |y|
  WIDTH.times do |x|
    vectors.each do |vector|
      count +=1 if XMAS.chars.each.with_index.all? do |char, i|
        scaled_x = vector[0] * i + x
        scaled_y = vector[1] * i + y
        (
          (0...WIDTH).cover?(scaled_x) && 
          (0...HEIGHT).cover?(scaled_y) &&
          map[scaled_y][scaled_x] == char
        )
      end
    end
  end
end

puts count
