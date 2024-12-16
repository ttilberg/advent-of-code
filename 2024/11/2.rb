stones = File.read('input.txt').scan(/\d+/).map(&:to_i).tally

75.times do |round|
  next_round = Hash.new(0)
  next_round[1] = stones.delete(0) || 0

  stones.each do |value, count|
    string_value = value.to_s
    size = string_value.size

    if size.even?
      left = string_value[0, size / 2].to_i
      right = string_value[size / 2, size / 2].to_i

      next_round[left] += count
      next_round[right] += count
    else
      next_round[(value * 2024)] += count
    end
  end

  stones = next_round
end

p stones.values.sum
