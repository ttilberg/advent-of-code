(🏌=->s,b,i=0{exit(p i) if b.slice(i,s).uniq.size==s;🏌[s,b,i+1]})[14,$<.read.bytes]

# Similar to:
# def go! size, input, start=0
#   return start if input.slice(start, size).uniq.count == size
#   go! size, input, start += 1
# end


# p go! 14, File.read("input.txt").bytes
