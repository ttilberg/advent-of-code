input = File.read('input.txt')

input.chars.each_cons(14).with_index do |chars, i|
  next if chars.tally.values.any?{|val| val > 1}
  puts i + 14
  break
end
