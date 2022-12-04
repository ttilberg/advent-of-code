POINTS = (("a".."z").zip(1..26) + ("A".."Z").zip(27..52)).to_h

score = File.read('input.txt').lines.sum do |line|
  left, right = line.scan(/.{#{line.size/2}}/).map(&:chars)
  POINTS[(left & right).first]
end

puts score
