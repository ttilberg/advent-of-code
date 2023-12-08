class Hand
  VALUES = 'A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2'.scan(/[0-9A-Z]/).reverse
  VALUE_SCORES = VALUES.zip(2..).to_h

  attr_reader :cards, :bid

  def initialize(cards, bid)
    @cards = cards.chars
    @bid = bid.to_i
  end

  def <=>(other)
    [hand_type_score, cards.map(&VALUE_SCORES)] <=> [other.hand_type_score, other.cards.map(&VALUE_SCORES)]
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
    ].find.with_index do |method, i|
      if send(method)
        break 0 - i
      end
    end
  end

  def freq
    @freq ||= cards.tally.values.sort
  end

  def five_of_a_kind?
    freq.count == 1
  end

  def four_of_a_kind?
    freq.any? 4
  end

  def full_house?
    freq == [2, 3]
  end

  def three_of_a_kind?
    freq.any? 3
  end

  def two_pair?
    freq == [1, 2, 2]
  end

  def one_pair?
    freq == [1, 1, 1, 2]
  end

  def high_card?
    freq.count == 5
  end
end

File.read('input.txt').lines.map do |line|
  Hand.new(*line.scan(/\S+/))
end
  .sort
  .map.with_index {|hand, i| hand.bid * (i + 1)}
  .sum
  .then {|sum| p sum}
