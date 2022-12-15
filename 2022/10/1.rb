class World
  attr_reader :tick_count
  attr_reader :signal
  def initialize
    @tick_count = 0

    @cmds = File.read("input.txt").split("\n")

    @signal = 1
    @cpu = []
  end

  def tick
    @tick_count += 1
    val = @cpu.shift || 0
    return if busy?
    
    @signal += val

    case @cmds.shift.split
    in ["noop"]
      @cpu << 0
    in ["addx", /[-0-9+]/ => val]
      @cpu += [0, val.to_i]
    end
  end

  def busy?
    @cpu.any?
  end

  def signal_str
    @signal * @tick_count
  end
end


world = World.new
key_cycles = [20, 60, 100, 140, 180, 220]
key_values = []
until world.tick_count > 220
  world.tick
  p tick: world.tick_count, signal: world.signal, str: world.signal_str
  if key_cycles.include? world.tick_count
    p tick: world.tick_count, signal: world.signal
    key_values << world.signal_str
  end
end

p key_values.sum