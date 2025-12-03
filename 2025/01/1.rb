i = 50
crossings = 0

File.foreach('input.txt') do |line|
  delta = line[/\d+/].to_i
  delta *= -1 if line.include? "L"
  i += delta
  crossings += 1 if (i % 100) == 0
end

p crossings
