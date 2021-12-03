class DiagnosticReport
  attr_reader :report
  attr_reader :gamma, :epsilon

  def initialize(report)
    @report = report.split.map(&:chars)
    scan!
  end

  def power_consumption
    gamma * epsilon
  end

  private

  # Transpose the bit array so we can scan each position
  # For each position, the `gamma` bit is whatever bit has highest frequency,
  #   and the `epsilson` bit is the other.
  # Convert the bits back to integers.
  def scan!
    @gamma, @epsilon = report.transpose.map do |bits|
      frequency = bits.tally
      frequency.sort_by {|_bit, freq| freq }.reverse.map(&:first)
    end.transpose.map(&:join).map{|bits| bits.to_i(2)}
  end
end

puts DiagnosticReport.new(File.read('data/3.txt')).power_consumption