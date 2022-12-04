POINTS = (("a".."z").zip(1..26) + ("A".."Z").zip(27..52)).to_h

score = File.read('input.txt').lines.map(&:chomp).map(&:chars).each_slice(3).sum do |a, b, c|
  POINTS[(a & b & c).first]
end

puts score
