def compare(left, right, i=0)
  l = left[i]
  r = right[i]

  return true if l.nil? && r.nil?
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

seperators = [[[2]], [[6]]]

lines = File.read("input.txt").scan(/.+/).map{|line| JSON.parse line} + seperators

sorted = nil
until sorted == true
  sorted = true
  lines.each_cons(2).with_index do |(left, right), i|
    # p(i:, left:, right:)

    if !compare(left, right)
      sorted = false
      lines[i] = right
      lines[i+1] = left
      # p :fail
      break
    end
    # p :ok
  end
end

p ?* * 20
pp lines
p seperators.map {|sep| lines.find_index(sep) + 1 }.reduce(&:*)

seperators = [[[2]], [[6]]]

lines = File.read("input.txt").scan(/.+/).map{|line| JSON.parse(line)} + seperators

p seperators.map{|sep| lines.count{|line| compare(line, sep)}}.reduce(&:*)
