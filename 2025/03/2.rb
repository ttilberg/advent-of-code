data = File.read('input.txt')
SLOTS = 12

data.lines.sum do |line|
  output = []
  vals = line.scan(/\d/)

  SLOTS.times.reverse_each do |position|
    scope = vals.take(vals.size - position)
    output << mark = scope.max
    this = vals.shift until this == mark
  end

  output.join.to_i
end.then {p it}
