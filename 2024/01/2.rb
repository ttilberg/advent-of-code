left, right = File.readlines('input.txt')
  .map(&:split)
  .transpose

counts = right.tally

puts left
  .map{|l| l.to_i * (counts[l] || 0)}
  .sum
