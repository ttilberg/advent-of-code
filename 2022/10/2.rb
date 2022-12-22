class Gizmo
  WIDTH = 40

  attr_reader :tick_count
  attr_reader :signal
  def initialize
    @tick_count = 0
    @stack = []
    @signal = 1

    parse_input!
  end

  def tick
    @tick_count += 1
    yield self if block_given?
    @signal += @stack.shift
  end

  def complete?
    @stack.empty?
  end

  private

  # The command list can act as a stack to shift each tick.
  #
  # A no-op cmd having a cooldown of 1 round is the same
  # as shifting off a 0 to add to the signal.
  #
  # Similarly, an add command takes two rounds, so
  # this is the same as [0, val]
  #
  # This means we can just always add 0 for each line,
  # and if an int exists, add that too.
  #
  def parse_input!
    File.read("input.txt").split("\n").each do |line|
      @stack << 0
      val = line[/[-0-9]+/]
      @stack << val.to_i if val
    end
  end

  def pixels
    [-1, 0, 1].map{|spread| signal + spread}
  end

  def x_cursor
    (tick_count - 1) % WIDTH
  end

  def nsync?
    pixels.include? x_cursor
  end

  def output
    val = nsync? ? '#' : '.'
    val << "\n" if x_cursor == WIDTH - 1
    val
  end
end


gizmo = Gizmo.new
until gizmo.complete?
  gizmo.tick {|gizmo| print gizmo.output }
end

