(🏌=->s,b,i=0{exit(p i+s) if b.slice(i,s).uniq.size==s;🏌[s,b,i+1]})[14,$<.read.bytes]

# # Similar to:
# def 🧐 size, input, start=0
#   return start + size if input.slice(start, size).uniq.count == size
#   🧐 size, input, start += 1
# end


# input = File.read("input.txt").bytes
# p 🧐 4, input
# p 🧐 14, input
