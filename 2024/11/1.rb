stones = File.read('input.txt').scan(/\d+/).map.with_index {|value, x| {value: value.to_i} }
# I smell lanternfish; but let's just take the easy path for now.

25.times do
  stones.each.with_index do |stone, i|
    if stone[:value] == 0
      stone[:value] = 1
      next
    end

    string_value = stone[:value].to_s
    if string_value.size.even?
      left, right = string_value.scan(Regexp.new(".{#{string_value.size / 2}}"))
      stones[i] = [
        {value: left.to_i},
        {value: right.to_i}
      ]
      next
    end

    stone[:value] *= 2024
  end

  stones.flatten!
end

p stones.count
