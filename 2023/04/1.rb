score = 0
File.read('input.txt').lines.each do |line|
  _card, winners, numbers = line.split(/[:|]/)
  winners = winners.scan(/\d+/)
  numbers = numbers.scan(/\d+/)

  my_winners = winners & numbers
  next if my_winners.empty?

  match_score = 2 ** (my_winners.count - 1)
  score += match_score
end

puts score
