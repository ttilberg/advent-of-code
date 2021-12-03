class WaterBilly
  attr_reader :depth, :distance, :aim

  def initialize
    @depth = 0
    @distance = 0
    @aim = 0
  end

  def forward(units)
    @distance += units
    @depth += aim * units
  end

  def up(units)
    @aim -= units
  end

  def down(units)
    @aim += units
  end
end

gizmo = WaterBilly.new

File.read('data/day-2-input.txt').each_line do |instruction|
  command, units = instruction.split(' ').map(&:strip)
  gizmo.public_send(command, units.to_i)
end

puts "Yar, we bein' #{gizmo.depth} undah 'n #{gizmo.distance} thingars away."
puts "For som'n reas'n we'n gun' multiplay thars t'gthars. She blars ar #{gizmo.depth * gizmo.distance}!"
