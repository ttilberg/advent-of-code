puts File.readlines('input.txt')
  .map(&:split)
  .transpose
  .map(&:sort)
  .transpose
  .map{|left, right| left.to_i - right.to_i}
  .map(&:abs)
  .sum
