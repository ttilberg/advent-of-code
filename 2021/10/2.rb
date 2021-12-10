POINTS = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

BUDDIES = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>',
}

scores = File.read('input.txt').split("\n").map do |line|
  score = 0
  stack = []

  line.chars.each do |char|
    if BUDDIES[char]
      stack << char
    elsif char == BUDDIES[stack.last]
      stack.pop
    else
      raise 'Skip'
    end
  end

  if stack.any?
    while char = stack.pop
      score *= 5
      score += POINTS[BUDDIES[char]]
    end
  end
  score
rescue
  nil
end.compact

p scores
p scores.sort[scores.size / 2]
