directories = Hash.new(0)

current_directory = []

File.read('input.txt').lines.each do |line|
  case line.split
  in ["$", "cd", ".."]
    current_directory.pop
  in ["$", "cd", dir]
    current_directory << dir
  in [/\d+/ => size, _file]
    # Load er up!
    path = []
    current_directory.each do |dir|
      path += [dir]
      directories[path] += size.to_i
    end
  else # no-op
  end
end

current_free = 70000000 - directories[["/"]]
to_delete = 30000000 - current_free

puts directories
  .values
  .select{|size| size <= 100_000}
  .sum

puts directories
  .values
  .select{|size| size > to_delete}
  .min
