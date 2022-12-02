LEFT = {
  "A" => :rock,
  "B" => :paper,
  "C" => :scissors
}

RIGHT = {
  "X" => :lose,
  "Y" => :draw,
  "Z" => :win
}

HAND_SCORE = {
  rock: 1,
  paper: 2,
  scissors: 3 
}

OUTCOME = {
  [:rock, :rock] => :draw,
  [:rock, :paper] => :win,
  [:rock, :scissors] => :lose,

  [:paper, :rock] => :lose,
  [:paper, :paper] => :draw,
  [:paper, :scissors] => :win,

  [:scissors, :rock] => :win,
  [:scissors, :paper] => :lose,
  [:scissors, :scissors] => :draw,  
}

SCORE = {
  win: 6,
  draw: 3,
  lose: 0
}

score = 0
File.readlines('input.txt').each do |line|
  left, right = line.split

  (them, me), result = OUTCOME.find{|(them, me), result| them == LEFT[left] && result == RIGHT[right]}

  score += HAND_SCORE[me]
  score += SCORE[result]
end

puts score