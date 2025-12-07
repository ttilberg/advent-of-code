data = File.read('input.txt')

map = Hash.new {|h, k| h[k] = []}
beams = Set.new
max_y = nil
data.lines.each.with_index do |line, y|
  max_y = y
  line.chars.each.with_index do |char, x|
    case char
    when ?S
      beams << x
    when ?^
      map[y] << x
    end
  end
end

super_splitters = Set.new
1.upto(max_y).each do |y|
  splitters = map[y]
  new_beams = beams.dup
  beams.each do |x|
    if splitters.include? x
      super_splitters << [x, y]
      new_beams += [x-1, x+1]
    end
  end
  new_beams -= splitters
  beams = new_beams
end

p super_splitters.count