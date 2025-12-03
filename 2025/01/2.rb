i = 50
crossings = 0

File.foreach('input.txt') do |line|
  delta = line[/\d+/].to_i
  direction = line.include?("L") ? -1 : 1
  delta.times do
    i += direction
    i = i %= 100
    crossings += 1 if i == 0
  end
end

p crossings
