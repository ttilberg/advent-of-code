puts File.read("input.txt").split("\n\n").map{|elf| elf.split("\n").map(&:to_i).sum}.max
