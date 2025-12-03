data = File.read('input.txt')

def invalid?(int)
  string = int.to_s
  mid = string.size / 2
  left = string[0, mid]
  left.size.downto(1).each do |i|
    return true if string.split(left[0, i]) == []
  end
  false
end

p data.split(',')
  .map {
    it.split('-').map(&:to_i).then { |min, max| min.upto(max).select {|val| invalid?(val) }.sum }
  }.sum
