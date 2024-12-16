def safe?(strange_values)
  return false unless [strange_values.sort, strange_values.sort.reverse].include? strange_values

  strange_values.each_cons(2).all? do |a, b|
    (1..3).cover? (a - b).abs 
  end
end

def safe_enough?(strange_values)
  return true if safe?(strange_values)
  strange_values.size.times do |i|
    stranger_values = strange_values.dup
    stranger_values.delete_at(i)
    return true if safe?(stranger_values)
  end
  false
end

vals = File.read('input.txt').lines.select do |line|
  strange_values = line.scan(/\d+/).map(&:to_i)

  safe_enough?(strange_values)
end
puts vals.count
