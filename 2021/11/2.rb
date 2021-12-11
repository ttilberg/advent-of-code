class World
  attr_reader :tick
  attr_reader :flashes
  attr_reader :flashes_today

  def initialize(input)
    @map = Hash.new
    input.split("\n").each_with_index do |line, y|
      line.chars.each_with_index do |val, x|
        @map[[x,y]] = Octopus.new(x, y, energy: val.to_i, world: self)
      end
    end

    @flashes = 0
    @flashes_today = 0
    @tick = 0
  end

  def solve!
    catch(:MY_EYES!) do
      loop do
        tick!
      end
    end

    tick
  end

  def tick!
    @flashes_today = 0
    @tick += 1

    @map.values.each(&:charge!)

    print_map

    throw :MY_EYES! if @map.values.all?(&:toast?)

    @map.values.each(&:sleep)
  end

  def print_map
    puts "Day: #{tick} -- Flashes: #{flashes} Today: #{flashes_today}"
    x = @map.keys.map{|x, y| x}.uniq.sort
    y = @map.keys.map{|x, y| y}.uniq.sort
    y.each do |_y|
      x.each do |_x|
        octoplop = @map[[_x, _y]]
        print octoplop.toast? ? '*' : octoplop.energy
      end
      print $/
    end
  end

  def flash!(octoplop)
    @flashes_today += 1
    @flashes += 1
    charge_neighbors(*octoplop.location)
  end

  
  DIRECTIONS = [
    [-1, -1],
    [ 0, -1],
    [ 1, -1],
    [-1,  0],
    [ 1,  0],
    [-1,  1],
    [ 0,  1],
    [ 1,  1]
  ].freeze

  def charge_neighbors(x, y)
    DIRECTIONS.each do |↔️, ↕️|
      neighbor = [x + ↔️, y + ↕️] 
      @map[neighbor]&.charge!
    end
  end

  class Octopus
    attr_reader :energy
    attr_reader :toast
    attr_reader :world
    attr_reader :x, :y

    alias toast? toast

    def initialize(x, y, energy:, world:)
      @world = world
      @x, @y = x, y
      @energy = energy
      @toast = false
    end

    def sleep
      if toast
        @energy = 0
        @toast = false
      end
    end

    def charge!
      @energy += 1
      zap! if energy > 9 && zesty?
    end

    def zesty?
      !toast
    end

    def zap!
      @toast = true
      world.flash!(self)
    end

    def location
      [x, y]
    end
  end
end

puts World.new(File.read('input.txt')).solve!
