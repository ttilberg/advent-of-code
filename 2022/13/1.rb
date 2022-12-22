def compare(left, right, i=0)
  l = left[i]
  r = right[i]

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

require "json"

vals =
  File.read("input.txt")
    .split("\n\n")
    .filter_map
    .with_index do |packets, i|
      left, right = packets.split("\n").map { |line| JSON.parse line }
      compare(left, right) && i + 1
    end

p vals.sum