risers = 0
File.read('input.txt').each_line
  .map(&:to_i)
  .each_cons(3).map(&:sum)
  .each_cons(2) do |near, far|
    risers += 1 if far > near
end

puts risers
