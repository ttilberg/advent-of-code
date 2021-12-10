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
    report.split("\n").each do |line|
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
      else
        # Skip lines that aren't horiz or vert
      end

    end

    overlaps.size
  end
end

puts SteamVentReport.new(File.read('input.txt')).analyze!


require 'minitest/autorun'
class Test < Minitest::Test
  def test_danger_zone
    assert_equal 5, SteamVentReport.new(SAMPLE).analyze!
  end
  SAMPLE = <<~TXT
    5,9 -> 0,9
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