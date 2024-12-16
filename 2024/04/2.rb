map = File.read('input.txt').lines.map(&:chars)

WIDTH = map.first.size
HEIGHT = map.size

MAS_EXTRACTIONS = [
  "MMASS".chars,
  "SSAMM".chars,
  "MSAMS".chars,
  "SMASM".chars
]

extraction_coords = [
  [-1, -1], [1, -1],
       [0, 0],
  [-1,  1], [1,  1]
]

count = 0

HEIGHT.times do |y|
  WIDTH.times do |x|
    extraction = extraction_coords.filter_map do |dx, dy|
      scaled_x = x + dx
      scaled_y = y + dy

      if (0...WIDTH).cover?(scaled_x) && (0...HEIGHT).cover?(scaled_y)
        map[scaled_y][scaled_x]
      end
    end
    if MAS_EXTRACTIONS.include? extraction
      count += 1
    end
  end
end

puts count
