require 'set'

class SteamVentReport
  attr_reader :report
  attr_reader :dots, :overlaps

  def initialize(report)
    @report = report
    @dots = Set.new
    @overlaps = Set.new
  end

  def analyze!
    report.lines.each do |line|
      x1, y1, x2, y2 = line.scan(/\d+/).map(&:to_i)
      case
      when x1 == x2
        Range.new(*[y1, y2].sort).each do |y|
          unless dots.add?([x1, y])
            overlaps << [x1, y]
          end
        end
      when y1 == y2
        Range.new(*[x1, x2].sort).each do |x|
          unless dots.add?([x, y1])
            overlaps << [x, y1]
          end
        end
      when (x2 - x1).abs == (y2 - y1).abs
        x_range = x1 < x2 ? x1..x2 : x1.downto(x2)
        y_range = y1 < y2 ? y1..y2 : y1.downto(y2)

        x_range.zip(y_range).each do |dot|
          unless dots.add? dot
            overlaps << dot
          end
        end
      else
        # This line is not 45 or 90
      end

    end

    overlaps.size
  end
end

puts SteamVentReport.new(File.read('input.txt')).analyze!


require 'minitest/autorun'
class Test < Minitest::Test
  def test_the_dangerous_ocean_floor
    assert_equal 12, SteamVentReport.new(SAMPLE).analyze!
  end
  SAMPLE = <<~TXT
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
  TXT
end