data = File.read('input.txt')

splitters = Hash.new {|h, k| h[k] = []}
beams = Hash.new(0)
max_y = nil

data.lines.each.with_index do |line, y|
  max_y = y
  line.chars.each.with_index do |char, x|
    case char
    when 'S' then beams[x] += 1
    when '^' then splitters[y] << x
    end
  end
end

1.upto(max_y).each do |y|
  beams
    .select {|x, particles| splitters[y].include?(x) && particles > 0}
    .each do |x, particles|
      beams[x] = 0
      beams[x - 1] += particles
      beams[x + 1] += particles
    end
end

p beams.values.sum
