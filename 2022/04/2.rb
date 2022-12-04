# Original submission:
i = 0
File.readlines("input.txt").each do |line|
  a, b = line.split(',').map{|guy| guy.split('-').map(&:to_i)}
  a = (a[0]..a[1]).to_a
  b = (b[0]..b[1]).to_a

  if (a & b).any?
    i +=1
  end
end
p i



# Variation:
File.readlines("input.txt").count do |line|
  a, b = line.split(',').map{|guy| guy.split('-').map(&:to_i)}
  a = Range.new(*a).to_a
  b = Range.new(*b).to_a

  (a & b).any?
end.then {|cnt| p cnt}
