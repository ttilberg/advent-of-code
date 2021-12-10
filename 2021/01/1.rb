risers = 0
File.read('input.txt').each_line.each_cons(2) do |near, far|
  risers += 1 if far.to_i > near.to_i
end

puts risers
