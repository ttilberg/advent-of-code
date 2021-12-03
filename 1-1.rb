risers = 0
File.read('data/day-1-input.txt').each_line.each_cons(2) do |near, far|
  risers += 1 if far.to_i > near.to_i
end

puts risers
