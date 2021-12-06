class Fish
  attr_reader :spawn_in
  def initialize(spawn_in=8)
    @spawn_in = spawn_in
  end

  def spawning?
    spawn_in == 0
  end

  def tick(world)
    if spawning?
      world[:new_fish] << Fish.new(8)
      @spawn_in = 6
    else
      @spawn_in -= 1
    end
  end
end

sample = <<~TXT
  3,4,3,1,2
TXT

world = {fish: [], new_fish: []}

File.read('input.txt').split(',').map(&:to_i).each do |spawn_in|
  world[:fish] << Fish.new(spawn_in)
end

80.times {
  world[:fish].each{ |fish| fish.tick(world) }
  world[:fish] += world[:new_fish]
  world[:new_fish] = []
}

puts world[:fish].size
