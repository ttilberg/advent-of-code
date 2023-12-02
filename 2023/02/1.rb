RULES = [12, 13, 14]

score = File.read('input.txt').lines.filter_map do |line|
  game, draws = line.split(": ")
  impossible = draws.split("; ").any? do |draw|
    [draw[/(\d+) red/], draw[/(\d+) green/], draw[/(\d+) blue/]]
      .map(&:to_i)
      .zip(RULES)
      .any? {|drawn, rule| drawn > rule}
  end

  next if impossible
  game[/\d+/].to_i
end.sum

puts score
