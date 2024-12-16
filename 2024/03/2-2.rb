puts ("do()" + File.read('input.txt'))
  .scan(Regexp.union(/mul\((\d+),(\d+)\)/, /(do)\(\)/, /(don't)\(\)/))
  .filter_map {|x, y, on, off| x.to_i * y.to_i if on..off }
  .sum
