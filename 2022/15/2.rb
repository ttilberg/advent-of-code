class Beacon
  @@beacons = {}

  def self.at(x, y)
    @@beacons[[x, y]]
  end

  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @@beacons[[x, y]] = self
  end
end


class Sensor
  @@sensors = {}

  def self.parse(string)
    x, y, beacon_x, beacon_y = string.scan(/[-0-9]+/).map(&:to_i)
    beacon = Beacon.at(beacon_x, beacon_y) || Beacon.new(beacon_x, beacon_y)
    new(x, y, beacon)
  end

  def self.at(x, y)
    @@sensors[[x, y]]
  end

  attr_reader :x, :y, :beacon

  def initialize(x, y, beacon)
    @x, @y = x, y
    @beacon = beacon
    @@sensors[[x, y]] = self
  end

  def signal_strength
    @signal_strength ||= (dx + dy).abs
  end

  def inspect
    {
      x:, y:, beacon_x: beacon.x, beacon_y: beacon.y, signal_strength:
    }
  end

  def horizontal_power_at_y(y2)
    attenuation = (y - y2).abs

    signal_strength - attenuation
  end

  def horizontal_minmax_at_y(y2)
    power = horizontal_power_at_y(y2)
    return nil if power < 1

    [x - power, x + power]
  end

  private

  def beacon_x = beacon.x
  def beacon_y = beacon.y

  def dx
    @dx ||= (x - beacon.x).abs
  end

  def dy
    @dy ||= (y - beacon.y).abs
  end

end

sensors = File.read("input.txt").split($/).map do |line|
  Sensor.parse(line)
end

MAP_SIZE = 4_000_000

x = 0
y = 0

loop do
  # p(x:, y:)

  last_x = x

  sensors.each.with_index do |sensor, i|
    min, max = sensor.horizontal_minmax_at_y(y)
    if min
      if min <= x && x <= max
        # p "Signal until #{max} due to sensor #{i}"
        x = max
        break
      end
    end
  end

  if last_x == x
    puts "We found a winner? #{x}, #{y}: #{x * MAP_SIZE + y}"
    exit
  else
    x += 1
  end

  if x > MAP_SIZE
    x = 0
    y += 1
  end
  raise "No results found" if y > MAP_SIZE
end
