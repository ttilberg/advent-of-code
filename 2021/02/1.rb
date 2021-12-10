class WaterBilly
  attr_reader :depth, :x

  def initialize
    @depth = 0
    @x = 0
  end

  def forward(distance)
    @x += distance
  end

  def up(distance)
    @depth -= distance
  end

  def down(distance)
    @depth += distance
  end
end

gizmo = WaterBilly.new

File.read('input.txt').each_line do |instruction|
  direction, amplitude = instruction.split(' ').map(&:strip)
  gizmo.public_send(direction, amplitude.to_i)
end

puts "Yar, we bein' #{gizmo.depth} undah 'n #{gizmo.x} thingars away."
puts "For som'n reas'n we'n gun' multiplay thars t'gthars. She blars ar #{gizmo.depth * gizmo.x}!"
