    stacks, instructions = File.read('input.txt').split("\n\n")

    # This wouldn't work as directly if the input had more than 9 piles.

    # Flip the input upside down and on it's side:
    stacks = stacks.split("\n").map(&:chars).reverse.transpose
    # We now have `1ZN `, `2MCD`, `3P  ` and a bunch of garbage lines
    #
    # [ [" ", "[", "[", " "],
    #   ["1", "Z", "N", " "],
    #   [" ", "]", "]", " "],
    #   [" ", " ", " ", " "],
    #   [" ", "[", "[", "["],
    #   ["2", "M", "C", "D"],
    #   [" ", "]", "]", "]"],
    #   [" ", " ", " ", " "],
    #   [" ", "[", " ", " "],
    #   ["3", "P", " ", " "],
    #   [" ", "]", " ", " "] ]

    stacks = stacks.select{|first, *rest| first.match?(/\d+/) }
    # We no longer have garbage lines.

    # But we still have " " at the end of the lists.
    stacks.map{|list| list.delete(" ")}

    # Now we turn it into a hash for easy operation management:
    stacks = stacks.map{|first, *rest| [first, rest]}.to_h


    instructions.split("\n").each do |instruction|
      move, from, to = instruction.scan(/\d+/)
      move.to_i.times do
        stacks[to] << stacks[from].pop
      end

    end


    puts stacks.values.map(&:last).join