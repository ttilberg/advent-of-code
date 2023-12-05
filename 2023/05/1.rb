seeds, *data = File.read('input.txt').split("\n\n")

RULES = Hash.new{|h, k| h[k] = []}

data.each do |map|
  name, _, *instructions = map.split
  from, to = name.split('-to-')

  instructions.map(&:to_i).each_slice(3) do |destination, source, range|
    offset = destination - source
    coverage = Range.new(source, source + range - 1)

    RULES[from] << [
      # Test to choose this rule
      -> input {coverage.include?(input)},
      # Fn to apply the rule
      -> input {[to, input + offset]}
    ]
  end
  RULES[from] << [ -> input {true}, -> input {[to, input]}]
end

samples = seeds.scan(/\d+/).map(&:to_i).map do |value|
  type = "seed"
  loop do
    rules = RULES[type]
    break if rules.empty?
    _test, fn = rules.find {|test, fn| test.call(value)}
    type, value = fn.call(value)
  end
  [type, value]
end

p samples.min_by{|type, value| value}
