rules, updates = File.read('input.txt').split("\n\n")

rules = rules.split.map do |pair|
  pair.split('|').map(&:to_i)
end

updates = updates.split.map do |line|
  line.split(',').map(&:to_i)
end

updates.select do |update|
  rules.all? do |validation|
    check = update & validation
    check.size < 2 || check == validation
  end
end
.sum {|update| update[update.size / 2] }
.then {|answer| puts answer}
