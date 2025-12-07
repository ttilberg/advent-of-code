data = File.read('input.txt')

d = data.lines(chomp: true).map(&:chars).transpose.reverse.map(&:join)
stack = []
d.reduce(0) do |sum, line|
  op = line[/[+*]/]
  stack << line.to_i if line[/\d/]
  sum += stack.reduce(op.to_sym) and stack.clear if op
  sum
end.then {p it}
