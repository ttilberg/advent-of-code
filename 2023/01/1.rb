val = File.read('input.txt').lines.sum do |line|
  a, *_, b = line.scan(/\d/)
  b = a unless b
  (a + b).to_i
end

p val