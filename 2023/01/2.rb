map = %w[zero one two three four five six seven eight nine].each.with_index.to_h.transform_values(&:to_s)
backmap = map.transform_keys(&:reverse)

forward = Regexp.union(/\d/, *map.keys)
backward = Regexp.union(/\d/, *backmap.keys)

val = File.read('input.txt').lines.sum do |line|
  a = line[forward]

  # This step was nutty. `twone`. You rascal.
  # But the crazier thing is... if it's at the end, then `two` matches first, becoming `2ne`, skipping the one.
  # so I guess we should scan in reverse? So weird.
  # I tried finding if there was a "don't consume matches"
  # Looking forward to see how other people do this...
  b = line.reverse[backward]

  b = a if b.nil?

  a = map[a] || a
  b = backmap[b] || b

  (a + b).to_i
end

p val
