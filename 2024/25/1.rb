locks = []
keys = []
height = nil

File.read('input.txt').split("\n\n").each do |device|
  pins = device.split.map(&:chars).transpose.map do |chars|
    height ||= chars.count
    chars.count('#')
  end

  if device[0] == "#"
    locks << pins
  else
    keys << pins
  end
end

score = 0

locks.each do |lock|
  keys.each do |key|
    if lock.zip(key).map(&:sum).all? { |val| val <= height }
      score += 1
    end
  end
end

puts score
