sample = <<~TXT
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
TXT

SCORES = {}
DOORS = {}

File.read('input.txt').lines.each do |line|
  name = line[/Valve (\w+)/, 1]
  score = line[/rate=(\d+)/, 1].to_i
  doors = line[/valves? (.*)/, 1].split(', ')

  SCORES[name] = score
  DOORS[name] = doors
end

# Determine which valves are worth opening
# => [1, 2, 3, 4, 5]
# Calculate distances between nodes
# Explore all combinations of opening the valves worth opening with given time allowance
# => [1, 2, 3, 4, 5]
# => [1, 2, 3, 5, 4]
# => [1, 2, 4, 3, 5]
# => [1, 2, 3, 4, 5]

DISTANCES = {}
DOORS.keys.each{|door| DISTANCES[[door, door]] = 0}

def distance_from(start, finish)
  return 0 if start == finish

  visited = []
  visited << start
  horizon = [start]
  next_horizon = []
  i = 0

  while node = horizon.shift
    break if node == finish
    to_visit = DOORS[node] - visited
    visited += to_visit
    next_horizon += to_visit

    if horizon.empty?
      horizon = next_horizon
      next_horizon = []
      i += 1
    end
  end

  return i
end

DOORS.keys.each do |start|
  DOORS.keys.each do |finish|
    DISTANCES[[start, finish]] = distance_from(start, finish)
  end
end

# Now that we know the distance between doors
# We can focus on goals
# Doors that give points are the only important targets.
# We want to walk all permutations and find which yields the highest score
#
# [[1, 2, 3, 4],
#  [1, 2, 4, 3],
#  [1, 3, 2, 4],
#  [1, 3, 4, 2],
#  [1, 4, 2, 3],
#  [1, 4, 3, 2],
#  [2, 1, 3, 4],
#  [2, 1, 4, 3],
#  [2, 3, 1, 4],
#  [2, 3, 4, 1],
#  [2, 4, 1, 3],
#  [2, 4, 3, 1],
#  [3, 1, 2, 4],
#  [3, 1, 4, 2],
#  [3, 2, 1, 4],
#  [3, 2, 4, 1],
#  [3, 4, 1, 2],
#  [3, 4, 2, 1],
#  [4, 1, 2, 3],
#  [4, 1, 3, 2],
#  [4, 2, 1, 3],
#  [4, 2, 3, 1],
#  [4, 3, 1, 2],
#  [4, 3, 2, 1]]
# ^--- Which one gave best score?

SCORING_DOORS = SCORES.select{|door, score| score > 0}.map{|door, score| door}

def search(current_node, opened=[], time=30, score=0, high_score=0)
  return high_score if time <= 0 || (SCORING_DOORS - opened).empty?
  # Can open this door
  if !opened.include?(current_node)
    opened_it_score = score + SCORES[current_node] * (time - 1)

    high_score = [high_score, opened_it_score].max
    opened += [current_node]
    (SCORING_DOORS - opened).each do |next_door|
      distance = DISTANCES[[current_node, next_door]]
      next if time - distance - 1 <= 0
      high_score = [high_score, search(next_door, opened, time - distance - 1, opened_it_score, high_score)].max
    end
  end

  # Or go somewhere else
  (SCORING_DOORS - opened).each do |next_door|
    distance = DISTANCES[[current_node, next_door]]
    next if time - distance <= 0
    high_score = [search(next_door, opened, time - distance, score, high_score), high_score].max
  end

  return high_score
end

puts search('AA')