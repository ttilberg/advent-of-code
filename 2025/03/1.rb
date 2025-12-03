data = File.read('input.txt')

data.lines.sum do |line|
  vals = line.scan(/\d/).map(&:to_i)
  mark = vals[0..-2].max
  tens = vals.shift until tens == mark
  ones = vals.max
  tens * 10 + ones
end.then {p it}
