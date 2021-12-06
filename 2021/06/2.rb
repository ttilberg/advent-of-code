fish = File.read('input.txt')
  .split(',')
  .map(&:to_i)
  .tally

fish.default = 0

256.times do
  fish.transform_keys! {|days| days - 1 }
  fish[8] = fish[-1]
  fish[6] += fish[-1]
  fish[-1] = nil
end
puts fish.values.compact.sum
