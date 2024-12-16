vals = File.read('input.txt').lines.select do |line|
  strange_values = line.scan(/\d+/).map(&:to_i)
  next unless [strange_values.sort, strange_values.sort.reverse].include? strange_values
  strange_values.each_cons(2).all? do |a, b|
    (1..3).cover? (a - b).abs 
  end
end
puts vals.count
