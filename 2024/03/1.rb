puts File.read('input.txt')
  .scan(/mul\((\d+),(\d+)\)/)
  .map {|x, y| x.to_i * y.to_i}
  .sum
