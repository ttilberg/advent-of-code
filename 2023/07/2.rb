class Hand
  VALUES = 'A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, or 2, J'.scan(/[0-9A-Z]/).reverse
  VALUE_SCORES = VALUES.zip(1..).to_h

  attr_reader :cards, :bid

  def initialize(cards, bid=0)
    @cards = cards.chars
    @bid = bid.to_i
  end

  def <=>(other)
    score <=> other.score
  end

  def score
    [hand_type_score, hand_value_score]
  end

  def hand_type_score
    %i[
      five_of_a_kind?
      four_of_a_kind?
      full_house?
      three_of_a_kind?
      two_pair?
      one_pair?
      high_card?
    ].each.with_index do |method, i|
      return 0 - i if send(method)
    end
    raise "Well shucks. What kind of hand is this? [#{cards}]"
  end

  def hand_value_score
    cards.map(&VALUE_SCORES)
  end

  def freq
    @freq ||= (cards - ['J']).tally.values.sort
  end

  def jokers
    @jokers ||= cards.count('J')
  end

  def five_of_a_kind?
    freq.any?(5 - jokers) || jokers == 5
  end

  def four_of_a_kind?
    freq.any?(4 - jokers)
  end

  def full_house?
    [jokers, freq] in 
      [0, [2, 3]] |
      [1, [2, 2]] |
      [2, [1, 2]]
  end

  def three_of_a_kind?
    freq.any?(3 - jokers)
  end

  def two_pair?
    [jokers, freq] in
      [0, [1, 2, 2]] |
      [1, [1, 1, 2]]
  end

  def one_pair?
    freq.any?(2 - jokers)
  end

  def high_card?
    freq.all?(1) && jokers == 0
  end
end


File.read('input.txt').lines
  .map {|line| Hand.new(*line.scan(/\S+/))}
  .sort
  .map.with_index {|hand, i| hand.bid * (i + 1)}
  .sum
  .then {|sum| p sum}
