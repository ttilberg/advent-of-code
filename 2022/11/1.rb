require 'pry'

sample = <<~TXT
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
TXT

class Jerk
  # After each monkey inspects an item but before it tests your worry level,
  # your relief that the monkey's inspection didn't damage the item causes
  # your worry level to be divided by three and rounded down to the nearest
  # integer.

  attr_reader :items
  attr_reader :item_goes_to
  attr_reader :inspections

  def initialize(items:  ,op: , test: )
    items = items.split(",").map(&:to_i) if items.is_a? String
    @items = Array(items)

    @op = Jerk.parse_op(op)
    @item_goes_to = Jerk.parse_test(test)
    @inspections = 0
  end

  def whats_this?(item)
    @inspections += 1
    @op.call(item)
  end

  def you_can_have_this(item)
    @item_goes_to.call(item)
  end

  def inspect
    {inspections: }
  end

  def self.parse_op(cmd)
    op, val = cmd.split[-2, 2]
    # This is dumb, but oh well.
    if val == "old"
      op = "**"
      val = 2
    end
    -> item {
      item.send(op.to_sym, val.to_i) / 3
    }
  end

  def self.parse_test(test)
    # Test: divisible by 3
    #   If true: throw to monkey 7
    #   If false: throw to monkey 0
    divisible_by, on_true, on_false = test.scan(/\d+/).map(&:to_i)
    -> item { 
      item.send(:%, divisible_by).zero? ?
        on_true :
        on_false
    }
  end
end

jerks = File.read("input.txt").split("\n\n").map do |monkey|
  items = monkey[/Starting items: (.*)/, 1]
  op = monkey[/Operation: .*/]
  test = monkey[/Test: .*/m]

  Jerk.new(items: items, op: op, test: test)
end

20.times do
  jerks.each do |jerk|
    while item = jerk.items.shift
      item = jerk.whats_this?(item)
      jerks[jerk.you_can_have_this(item)].items << item
    end
  end
end

p jerks.map(&:inspections).sort.last(2).reduce(&:*)
