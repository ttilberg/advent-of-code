input = '2333133121414131402'
# input = '23 33 13 31 21 41 41 31 40 2'

disk = []

File.read('input.txt').chars.each_slice(2).with_index do |(blocks, free_spaces), id|
  blocks, free_spaces = blocks.to_i, free_spaces.to_i

  blocks.times do
    disk << id
  end

  free_spaces.times do
    disk << nil
  end
end

i = 0
target = disk.compact.size

loop do
  if disk[i].nil?
    f = disk.pop
    until f
      f = disk.pop
    end

    disk[i] = f
  end

  break if disk[i...target].all?
  i += 1
end

binding.irb

sum = 0
i = 0
disk.each do |id|
  sum += i * id.to_i
  i += 1
end

p sum
