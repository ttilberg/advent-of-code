require 'delegate'

class Puzzle
  attr_reader :lines
  def initialize(input)
    @lines = input.split($/).map{|line| Line.new(line)}
  end

  def solve!
    lines.map(&:total).sum
  end

  class InputArray
    include Enumerable
    attr_reader :values

    def initialize(input)
      @values = input.split.map {|word| Value.new(word)}
    end

    def each
      values.each {|v| yield v}
    end

    def mask_map
      @mask_map ||= values.map{|val| [val.mask, val.solved_value]}.to_h
    end

    # I had high hopes to automatically cycle through a bunch of bitmaps,
    # reducing the candidates for each slot until only one made sense.
    # I couldn't figure it out. So I ended up taking my bitmapping experience
    # and brute forcing through the input list with known transformations.
    #
    def solve!
      return if solved_values.all?
      # xxxxxxxxxx
      one = find_solved_number 1
      seven = find_solved_number 7
      four = find_solved_number 4
      eight = find_solved_number 8

      # 1xx4xx78xx

      # Next, solving 5 char vals, the 3 should include the vals from 1, and the others won't include both
      five_char_vals = values.select{|val| val.mask.to_s(2).count('1') == 5}

      three = five_char_vals.find {|val| one.mask & val.mask == one.mask}
      three.solved_value = 3

      five_char_vals.delete(three)

      # 1x34xx78xx

      # The 4 mask will include 2 components of 2, and 3 components of 5
      # There will only be two, so we can nicely sort and splat these.
      two, five = five_char_vals.sort_by{|val| (four.mask & val.mask).to_s(2).count('1')}
      two.solved_value = 2
      five.solved_value = 5

      # 12345x78xx

      # Next up is 6 char vals:
      # 0, 6, 9
      six_char_vals = values.select{|val| val.mask.to_s(2).count('1') == 6}

      # the 6 will not include 1 (cg)
      six = six_char_vals.find{|val| one.mask & val.mask != one.mask}
      six.solved_value = 6
      six_char_vals.delete(six)

      # 12345678xx

      # Comparing 5 to 6 gives us the lower left value (e).

      # ab d fg => 5
      # ab defg => 6
      #     ^
      # abcd fg => ?
      #  bcdefg => ?

      lower_left = six.mask ^ five.mask

      # The 0 includes the lower left value e

      # ab defg => 6
      # abcd fg => 9
      #  bcdefg => 0

      # Or, said another way, of the remaining 9 and 0, the 9 will _not_ include the bottom left.
      # So we can sort by the union of the masks and get this done already... ; ;
      nine, zero = six_char_vals.sort_by{|val| val.mask & lower_left}
      nine.solved_value = 9
      zero.solved_value = 0

      # WOOF.
    end

    private

    def solved_values
      values.map(&:solved_value)
    end

    def find_solved_number(num)
      values.find{|val| val.solved_value == num}
    end
  end

  class OutputArray
    include Enumerable

    attr_reader :values

    def initialize(output)
      @values = output.split.map {|word| Value.new(word)}
    end

    def digits
      values.map(&:solved_value)
    end

    def each
      values.each {|val| yield val}
    end
  end

  class Value < SimpleDelegator
    CHARS_TO_BINARY = {
      'a' => 0b1000000,
      'b' => 0b0100000,
      'c' => 0b0010000,
      'd' => 0b0001000,
      'e' => 0b0000100,
      'f' => 0b0000010,
      'g' => 0b0000001
    }

    NUM_TO_LETTERS = {
      1 => 'cf',
      7 => 'acf',
      4 => 'bcdf',
      2 => 'acdeg',
      3 => 'acdfg',
      5 => 'abdfg',
      0 => 'abcefg',
      6 => 'abdefg',
      9 => 'abcdfg',
      8 => 'abcdefg'
    }

    NUM_TO_LETTER_SIZES = NUM_TO_LETTERS.transform_values(&:size)    

    attr_accessor :solved_value

    def value
      self.to_s
    end

    def mask
      @mask ||= value.chars.map{|char| CHARS_TO_BINARY[char]}.reduce(&:|)
    end

    def solved_value
      return @solved_value if @solved_value

      if candidates.size == 1
        @solved_value = candidates.first
      end
    end

    # Given the size of this value,
    # detect the potential values this could be based on the string size
    def candidates
      @candidates ||= NUM_TO_LETTER_SIZES
        .select{|keys, values| size == values}
        .keys
    end
  end


  class Line
    attr_reader :input_array, :output_array

    def initialize(line)
      @input_array, @output_array = line.split(' | ')
      @input_array = InputArray.new(@input_array)
      @output_array = OutputArray.new(@output_array)
    end

    def total
      @total ||= code.join.to_i
    end

    def code
      @code ||= solve!
    end

    def solve!
      input_array.solve!

      output_array.map do |val|
        input_array.mask_map[val.mask]
      end
    end

  end  
end

puts Puzzle.new(File.read('input.txt')).solve!
