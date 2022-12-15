sample = <<~TXT
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
TXT

def compare(left, right, i=0)
  p(left:, right:, i:)


  l = left[i]
  r = right[i]

  p(l:, r:)
  return compare(left, right, i+1) if l == r

  if l.is_a?(Array) && r.is_a?(Numeric)
    return true if l.empty?
    return compare(left, right, i+1) if l == [r]
    return compare(l, [r])
  end

  if r.is_a?(Array) && l.is_a?(Numeric)
    return false if r.empty?
    return compare(left, right, i+1) if [l] == r

    return compare([l], r)
  end

  return compare(l, r) if [l, r].all?(Array)


  return true if l.nil? && r
  return false if l && r.nil?
  return true if l < r
  return false if l > r
  compare(left, right, i + 1)
end

# def compare(left, right)
#   loop do
#     p(left:, right:)
#     l = left.shift
#     r = right.shift

#     p(l:, r:)

#     if l == r
#       next
#     end

#     return true if l.nil? && r
#     return false if l && r.nil?

#     if [l, r].one?(Array) && [l, r].one?(Numeric)
#       left.unshift(Array(l))
#       right.unshift(Array(r))
#       next
#     end

#     return true if l < r
#     return false if l > r
#   end
# end

require "json"

vals =
  File.read("input.txt")
    .split("\n\n")
    .filter_map
    .with_index do |packets, i|
      left, right = packets.split("\n").map { |line| JSON.parse line }
      p "*******   #{i}   ***********"

      (p compare(left, right)) && i + 1
    end

p vals.sum