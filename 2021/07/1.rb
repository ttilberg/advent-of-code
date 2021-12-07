SAMPLE = <<~TXT
16,1,2,0,4,2,7,1,2,14
TXT

crabs = File.read('input.txt').scan(/\d+/).map(&:to_i)

# I'm not sure if this was just luck, but median felt intuitively like "something".
# It worked for the sample dataset, and (somewhat surprisingly) worked for the official set.
# I also perhaps got lucky with this chumpy version of median,
# where if the input set was even, I'm not averaging the two middle numbers.
target_position = crabs.sort[crabs.size / 2]

pp crabs.map{|crab| (target_position - crab).abs}.sum
