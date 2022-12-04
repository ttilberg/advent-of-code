template, rules = File.read('input.txt').split("\n\n")

template = template.chars
rules = rules.split($/).map{|line| line.split(' -> ')}.to_h

rules.transform_keys!{|key| key.chars}

10.times do
  middle = []
  template.each_cons(2) do |l, r|
    middle << rules[[l, r]]
  end
  
  template = template.zip(middle).flatten.compact
end

counts = template.tally.values
p counts.max - counts.min
