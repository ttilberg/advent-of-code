crabs = File.read('input.txt').scan(/\d+/).map(&:to_i)

# Median no longer feels intuitive, but I figured there's gotta be a mathypattern.
# I suppose I'll try avg. Surprisingly, the avg of the sample dataset came to
# 4.9, which was suspiciously near 5, which the example says is the right number.
#
# .round ended up giving the right answer in the sample dataset, but not the larger set.
# Assuming the idea of using the average is helpful in some way (it seems like it could be?)
# I figured the right answer was somewhere around there.
# To get the answer I printed the results for the target position range of -10..+10 just as a sanity check
# and was delighted to find the low fuel actually was burried in there, right at the equivalent of Math.floor...
#
# I'm not sure if this was just luck or not, but here's my "followed through" version:

avg = (1.0 * crabs.sum / crabs.size)
fuel = [avg.floor, avg.ceil].map do |target_position|
  crabs.map do |crab|
    moves = (target_position - crab).abs
    1.upto(moves).sum
  end.sum
end.min

puts fuel
