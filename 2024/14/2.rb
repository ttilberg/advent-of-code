file = 'input.txt'

robots = File.read(file).lines.map {|line|
  x, y, dx, dy = line.scan(/-?\d+/).map(&:to_i)
  {x:, y:, dx:, dy:}
}

WIDTH = ENV['SAMPLE'] ? 11 : 101
HEIGHT = ENV['SAMPLE'] ? 7 : 103

time = 0

# After printing the robot grid for a few hundred rounds, I noticed that 
# every 101 frames, starting from 14 looked "more organized" than others.
# Being that 101 is the width of the map value, I thought I should print
# at each interval of W and H loops. Offset by frame 14.
#
# To my surprise, it worked after a few rounds. /shrug.
#
loop do
  if time % WIDTH == 14 || time % HEIGHT == 14
    robot_map = Set.new(robots.map do |robot|
      [robot[:x], robot[:y]]
    end)

    p(time: )
    HEIGHT.times do |y|
      WIDTH.times do |x|
        char = robot_map.include?([x, y]) ? '#' : '.'
        print char
      end
      print $/
    end

    puts $/ * 2

    gets
  end

  robots.each do |robot|
    robot[:x] += robot[:dx]
    robot[:x] = robot[:x] % WIDTH
    robot[:y] += robot[:dy]
    robot[:y] = robot[:y] % HEIGHT
  end
  time += 1
end
