class Jerk
  attr_reader :items
  attr_reader :item_goes_to
  attr_reader :inspections
  attr_reader :divisor

  def initialize(text)
    @items         = parse_items(text)
    @inspection_fn = parse_inspection_fn(text)
    @deliver_to_fn = parse_deliver_to_fn(text)
    @inspections = 0
  end

  def whats_this?(item)
    @inspections += 1
    @inspection_fn.call(item)
  end

  def thinks_he_is_funny_with_an(item)
    @deliver_to_fn.call(item)
  end

  private

  def parse_items(text)
    text[/Starting items: (.*)/, 1].split(",").map(&:to_i)
  end

  def parse_inspection_fn(text)
    cmd = text[/Operation: (.*)/, 1]
    op, val = cmd.split[-2, 2]
    # This is dumb, but oh well.
    if [op, val] == ["*", "old"]
      op, val = "**", 2
    end

    -> item { item.send(op.to_sym, val.to_i) }
  end

  def parse_deliver_to_fn(text)
    @divisor, on_true, on_false = text[/Test: .*/m].scan(/\d+/).map(&:to_i)

    -> item { item.send(:%, divisor).zero? ? on_true : on_false }
  end
end

jerks = File.read("input.txt").split("\n\n").map do |monkey|
  Jerk.new(monkey)
end

very_divisive = jerks.map(&:divisor).reduce(&:*)

10_000.times do
  jerks.each do |jerk|
    while item = jerk.items.shift
      item = item % very_divisive if item > very_divisive
      item = jerk.whats_this?(item)
      jerks[jerk.thinks_he_is_funny_with_an(item)].items << item
    end
  end
end

p jerks.map(&:inspections).sort.last(2).reduce(&:*)
