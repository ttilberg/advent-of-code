map = %w[zero one two three four five six seven eight nine].each.with_index.to_h.transform_values(&:to_s)

pattern = Regexp.union(/\d/, *map.keys)

val = File.read('input.txt').lines.sum do |line|
  a = line[pattern]
  b = line[/.*(#{pattern})/, 1]

  a = map[a] || a
  b = map[b] || b

  (a + b).to_i
end

p val
