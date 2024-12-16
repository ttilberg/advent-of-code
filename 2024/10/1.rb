MAP = {}
start_points = Set.new

File.read('input.txt').lines.each.with_index do |line, y|
  line.chomp.chars.each.with_index do |height, x|
    MAP[[x, y]] = height.to_i
    start_points << [x, y] if height.to_i == 0
  end
end

EXIT_POINTS = {}

def next_paths_for(x, y)
  if candidates = EXIT_POINTS[[x, y]]
    return candidates
  end

  height = MAP[[x, y]]

  neighbors = [
    [-1, 0],
    [1,  0],
    [0 ,-1],
    [0,  1]
  ].map {|dx, dy| [x + dx, y + dy] }

  # Filter for the correct height
  candidates = neighbors.select{|nx, ny| MAP[[nx, ny]] == height + 1 }

  # Cache the answer
  EXIT_POINTS[[x, y]] = candidates
end


TRAILS = Set.new

def walk(x, y, base_x, base_y)
  # puts "(#{x}, #{y}): #{MAP[[x, y]]}"
  if MAP[[x, y]] == 9
    # puts "Found an exit"
    TRAILS << [[base_x, base_y], [x, y]]
    return 1
  end

  next_paths = next_paths_for(x, y)
  return 0 if next_paths.empty?

  next_paths.sum do |next_x, next_y|
    walk(next_x, next_y, base_x, base_y)
  end
end

start_points.sum do |start_point|
  walk(*start_point, *start_point)
end

p TRAILS.count
