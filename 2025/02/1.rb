data = File.read('input.txt')

def invalid?(int)
  string = int.to_s
  mid = string.size / 2
  left = string[0, mid]
  right = string[mid..]
  left == right
end

p data.split(',')
  .map {
    it.split('-').map(&:to_i).then { |min, max| min.upto(max).select {|val| invalid?(val) }.sum }
  }.sum
