class Point
  attr_reader :x, :y, :z
  attr_accessor :circuit
  def initialize(x, y, z)
    @x, @y, @z = x, y, z
    @circuit = nil
  end
  def to_a = [x, y, z]
  def -(other) = [x - other.x, y - other.y, z - other.z]
  def distance_from(other)
    (self - other).map!{|val| val.pow(2)}.sum.pow(0.5)
  end
  def <=>(other) = to_a <=> other.to_a
  def inspect = "#<Point: #{x}, #{y}, #{z}>"
end

input = File.read('input.txt')

points = input.lines.map {|line| Point.new(*line.scan(/\d+/).map(&:to_i))}
distances = {}

points.combination(2).each do |a, b|
  distances[[a, b].sort] = a.distance_from(b)
end

circuit_index = 0
circuits = Hash.new { |hash, key| hash[key] = Set.new }

distances.sort_by{|points, distance| distance}.take(1000).each do |(a, b), distance|
  circuit, merging_circuit = [a, b].map(&:circuit).compact.uniq

  if merging_circuit
    circuits[merging_circuit].each do |point|
      point.circuit = circuit
      circuits[circuit] << point
    end
    circuits[merging_circuit].clear
    next
  end

  if circuit.nil?
    circuit = circuit_index += 1
  end

  a.circuit = circuit
  b.circuit = circuit
  circuits[circuit] << a << b
end

p circuits.values.map(&:count).sort.last(3).reduce(&:*)
