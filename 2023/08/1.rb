codes, nodes = File.read('input.txt').split("\n\n")
nodes = nodes.lines.to_h {|line| line.scan(/[A-Z]+/).then{[_1, [_2, _3]]}}
at = 'AAA'
codes.chars.cycle.with_index do |i, steps|
  at = nodes[at][i == ?L ? 0 : 1]
  break steps if at == 'ZZZ'
end.then{p _1 + 1}
