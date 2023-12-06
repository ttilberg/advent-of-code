times, distances = File.read('input.txt').lines
  .map{|line| line.scan(/\d+/)
                  .map(&:to_i)}

scores = times.zip(distances).map do |time, record_distance|
  score = time.times.to_a.count do |hold_time|
    travel_time = time - hold_time
    distance = hold_time * travel_time

    distance > record_distance
  end

  score
end

p scores.reduce(&:*)
