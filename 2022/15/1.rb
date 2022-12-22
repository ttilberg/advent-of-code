require 'set'

sensors_to_beacons = {}
sensor_distance = {}
known_beacons = Set.new

File.read("input.txt").split($/).each do |line|
  sensor_x, sensor_y, beacon_x, beacon_y = line.scan(/[-0-9]+/).map(&:to_i)
  dx = (sensor_x - beacon_x).abs
  dy = (sensor_y - beacon_y).abs
  distance = dx + dy

  sensors_to_beacons[[sensor_x, sensor_y]] = [beacon_x, beacon_y]

  sensor_distance[[sensor_x, sensor_y]] = distance
  known_beacons << [beacon_x, beacon_y]
end

$target = 2_000_000

relevant_sensors = sensor_distance.select{|(x, y), dist| ((y - dist)..(y + dist)).include? $target }

coverages = relevant_sensors.map do |(x, y), dist|
  dt = (y - $target).abs

  power = dist - dt
  p(x:, y: , dist:, dt:, power:, beacon: sensors_to_beacons[[x, y]])

  range = Set.new((x - power)..(x + power))
  p(range_min: range.min, range_max: range.max)
  range
end

p coverages.reduce(&:+).to_a.sort.minmax

beacon_occlusion = known_beacons.select{|x, y| y == $target}.count

p beacon_occlusion: , coverage: coverages.reduce(&:+).count - beacon_occlusion
