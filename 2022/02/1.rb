THEM = {
  "A" => :rock,
  "B" => :paper,
  "C" => :scissors
}

ME = {
  "X" => :rock,
  "Y" => :paper,
  "Z" => :scissors
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
File.readlines("input.txt").each do |line|
  them, me = line.split
  score += HAND_SCORE[ME[me]]
  score += SCORE[OUTCOME[[THEM[them], ME[me]]]]
end

puts score