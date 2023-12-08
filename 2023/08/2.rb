# Cranky that I had the right strategy for lcm within just a few minutes
# but my original calculation to get A->Z gave me very wrong numbers
# Then I thought of the paradox where it isn't guaranteed to loop
# While it doesn't cycle back to the entrypoint, it does cycle back to step 2.

# So, I made this code extra cranky to account for my feelings on spending 4 hours
# on a 20 minute problem I had already basically solved and become convinced I was wrong.

codes, nodes = File.read('input.txt').split("\n\n")
nodes = nodes.lines.to_h {|line| line.scan(/[0-9A-Z]+/).then{[_1, [_2, _3]]}}
rat, at = [], nodes.keys.grep(/A$/)

codes.chars.cycle.with_index do |that, stat|
  at.map!{|node| nodes[node][that==?L?0:1]}
  rat+=at.grep(/Z$/).map{stat}
  break if at.filter!{!_1[/Z$/]}&.empty?
end

p rat.map(&:succ).reduce(&:lcm)
