def shrink(arr)
  return 0 if arr.all? 0

  next_arr = arr.each_cons(2).map {|l, r| r - l}
  arr.last + shrink(next_arr)
end

File.read('input.txt').lines.map do |line|
  ints = line.split.map(&:to_i)
  shrink(ints)
end
  .sum
  .then {p _1}
