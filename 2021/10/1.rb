POINTS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

BUDDIES = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>',
}

score = 0

File.read('input.txt').split("\n").each do |line|
  stack = []
  line.chars.each do |char|
    if BUDDIES[char]
      stack << char
    elsif char == BUDDIES[stack.last]
      stack.pop
    else
      score += POINTS[char]
      break
    end
  end
end

p score