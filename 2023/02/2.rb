score = File.read('input.txt').lines.map do |line|
  _game, draws = line.split(": ")
  draws = draws.split("; ").map do |draw|
    [draw[/(\d+) red/], draw[/(\d+) green/], draw[/(\d+) blue/]]
      .map(&:to_i)
  end
  p(draws:)

  draws.transpose.map(&:max).reduce(&:*)
end.sum

puts score
