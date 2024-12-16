SAMPLE = <<~TXT
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
TXT

SAMPLE_ARRANGEMENTS = [
  1,
  4,
  1,
  1,
  4,
  10,
]

class Line
  attr_reader :springs
  attr_reader :specs

  def initialize(line)
    springs, specs = line.split(' ')

    # springs in order from high to low
    @springs = springs.split(/\.+/).reject(&:empty?).sort_by(&:size).reverse
      .map(&:chars)
    # specs in order from high to low
    @specs = specs.scan(/\d+/).map(&:to_i).sort.reverse
  end

  def arrangements
    binding.irb

  end
end


require 'minitest/autorun'

class Test < Minitest::Test
  def test_1
    line = Line.new('???.### 1,1,3')
    assert_equal 1, line.arrangements
  end
end
