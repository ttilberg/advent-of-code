current_directory = []
files = {}

File.read('input.txt').lines.each do |line|
  case line.split
  in ["$", "cd", ".."]
    current_directory.pop
  in ["$", "cd", dir]
    current_directory << dir
  in [/\d+/ => size, file]
    files[current_directory + [file]] = size.to_i
  else
    # no-op
  end
end

directories = Hash.new(0)
files.each do |(*path, file), size|
  while(path.any?)
    directories[path.dup] += size
    path.pop
  end
end

puts directories.select{|path, size| size <= 100_000}.values.sum
