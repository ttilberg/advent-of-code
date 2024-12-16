puts ("do()" + File.read('input.txt'))
  .scan(/do\(\).*?(?:don't\(\)|\z)/m)
  .join
  .scan(/mul\((\d+),(\d+)\)/)
  .map {|x, y| x.to_i * y.to_i}
  .sum
