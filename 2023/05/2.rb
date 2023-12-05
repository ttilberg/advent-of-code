# Main idea:
# Work backwards from a location, and test to see if there's a
# valid seed.
# For example, location 0 chains the following values:
#   {:type=>"humidity", :value=>6504921}
#   {:type=>"temperature", :value=>26126051}
#   {:type=>"light", :value=>2815242703}
#   {:type=>"water", :value=>1485897419}
#   {:type=>"fertilizer", :value=>2707290099}
#   {:type=>"soil", :value=>3615169328}
#   {:type=>"seed", :value=>3774117185}
# But 3774117185 is not contained in a valid seed range.
#
# So, I guess we'll just brute force upwards until we land on a valid seed.
#
#
# Here was the result of my winning output, showing it taking 6 minutes.
# I was going to let it run overnight. :X
#
#  advent-of-code/2023/05  main ✗                                                            1d1h ◒
#  ▶ caffeinate -disu time ruby 2.rb
#  Found the winning seed: [2982244904, 2982244904..3320008701] at location: 20283860
#        372.54 real       369.94 user         2.45 sys
#

seeds, *definitions = File.read('input.txt').split("\n\n")

seed_ranges = seeds.scan(/\d+/).map(&:to_i)
  .each_slice(2).map{|seed, range|
    [
      seed, # The actual seed value. I guess it's not needed though.
      Range.new(seed, seed + range - 1)
    ]
  }

# Lookup hash for "I have this type, and want to convert it to a different type"
# {
#   # type =>
#   "location" => [
#     # rules
#     [
#       # fn to test if this is the good rule
#       -> {},
#       # fn to apply to value. Returns [next-type, value]
#       -> {}
#     ], [->{}, ->{}], [...], ...
#   ]
# }
RULES = Hash.new{|h, k| h[k] = []}

definitions.each do |definition|
  name, _, *instructions = definition.split
  from, to = name.split('-to-')

  # Parse custom functions:
  instructions.map(&:to_i).each_slice(3) do |destination, source, range|
    offset = source - destination
    coverage = Range.new(destination, destination + range - 1)

    RULES[to] << [
      # Test
      -> input {coverage.include?(input)},
      # Fn
      -> input {[from, input + offset]}
    ]
  end
  # And add identity function to the tail, which is always valid.
  RULES[to] << [ -> input {true}, -> input {[from, input]}]
end

# Starts from a location and transforms it across
# each rule until we end up with a seed (no more rules).
def find_seed_for_location(location)
  value = location
  type = "location"
  loop do
    rules = RULES[type]
    return value if rules.empty?
    _test, fn = rules.find {|test, fn| test.call(value)}
    type, value = fn.call(value)
  end
end

location = 0

loop do
  potential_seed = find_seed_for_location(location)

  if existing_seed = seed_ranges.find{|seed, range| range.include? potential_seed}
    puts "Found the winning seed: #{existing_seed} at location: #{location}"
    break
  end
  location += 1
end
