file = ENV['SAMPLE'] ? 'sample.txt' : 'input.txt'

robots = File.read(file).lines.map {|line|
  x, y, dx, dy = line.scan(/-?\d+/).map(&:to_i)
  {x:, y:, dx:, dy:}
}

WIDTH = ENV['SAMPLE'] ? 11 : 101
HEIGHT = ENV['SAMPLE'] ? 7 : 103

TIME = 100

robots.each do |robot|
  robot[:x] += robot[:dx] * TIME
  robot[:x] = robot[:x] % WIDTH
  robot[:y] += robot[:dy] * TIME
  robot[:y] = robot[:y] % HEIGHT
end

x_split = WIDTH / 2
y_split = HEIGHT / 2

robots
  .reject {|robot| robot[:x] == x_split || robot[:y] == y_split }
  .group_by do |robot|
    [
      robot[:x] < x_split,
      robot[:y] < y_split
    ]
  end
  .values
  .map(&:count)
  .reduce(&:*)
  .then {p _1}
