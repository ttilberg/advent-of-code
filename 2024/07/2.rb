def math(target, a, b=nil, *rest)
  # p(target:, a:, b:, rest:)
  if b.nil?
    # puts "Out of values, comparing #{target} to #{a}: #{target == a}"
    return a == target
  end

  if target < a + b && target < a * b
    # puts "More ops will bust. #{a} +/* #{b} > #{target}"
    return false
  end

  math(target, a + b, *rest) || math(target, a * b, *rest) || math(target, (a.to_s + b.to_s).to_i, *rest)
end

File.read('input.txt').lines.filter_map do |line|
  target, *vals = line.scan(/[-\d]+/).map(&:to_i)

  target if math(target, *vals)
end
.sum
.then {|it| puts it}
