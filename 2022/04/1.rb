# Original submission:
i = 0
File.readlines("input.txt").each do |line|
  a, b = line.split(',').map{|guy| guy.split('-').map(&:to_i)}
  a = (a[0]..a[1]).to_a
  b = (b[0]..b[1]).to_a

  if (a - b).empty? || (b-a).empty?
    i +=1
  end
end
p i



# Revision
File.readlines("input.txt").count do |line|
  a, b = line.split(',').map{|guy| guy.split('-').map(&:to_i)}
  a = (a[0]..a[1]).to_a
  b = (b[0]..b[1]).to_a

  (a - b).empty? || (b-a).empty?
end.then{p _1}

