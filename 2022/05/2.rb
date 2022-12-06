stacks, instructions = File.read('input.txt').split("\n\n")

# This wouldn't work as directly if the input had more than 9 piles.

stacks = stacks.split("\n").map(&:chars).reverse.transpose
stacks = stacks.select{|first, *rest| first.match?(/\d+/) }
stacks.map{|list| list.delete(" ")}
stacks = stacks.map{|first, *rest| [first, rest]}.to_h


    instructions.split("\n").each do |instruction|
      move, from, to = instruction.scan(/\d+/)

      # The only change is using `pop(n) rather than `n.times`
      new_and_improved_crate_mover_9001 = stacks[from].pop(move.to_i)

      stacks[to] += new_and_improved_crate_mover_9001
    end


puts stacks.values.map(&:last).join
