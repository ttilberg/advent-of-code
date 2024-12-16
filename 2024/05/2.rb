rules, updates = File.read('input.txt').split("\n\n")

rules = rules.split.map do |pair|
  pair.split('|').map(&:to_i)
end

sorters = {}
rules.each do |x, y|
  sorters[[x, y]] = 1
  sorters[[y, x]] = -1
end

updates = updates.split.map do |line|
  line.split(',').map(&:to_i)
end

updates.reject do |update|
  rules.all? do |validation|
    check = update & validation
    check.size < 2 || check == validation
  end
end
.map do |update|
  update.sort{|x, y| sorters[[x, y]]}[update.count / 2]
end
.sum
.then {puts _1}
