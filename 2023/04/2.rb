cards = Hash.new(0)
max_card = 0

File.read('input.txt').lines.each do |line|
  card, winners, numbers = line.split(/[:|]/)
  card = card[/\d+/].to_i
  winners = winners.scan(/\d+/)
  numbers = numbers.scan(/\d+/)

  max_card = card

  cards[card] += 1

  my_winners = winners & numbers
  next if my_winners.empty?

  my_winners.count.times do |i|
    cards[card + i + 1] += cards[card]
  end
end

cards.delete_if {|k, v| k > max_card}

puts cards.values.sum