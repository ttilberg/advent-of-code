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

DISK_SIZE = 70000000
NEED_FREE = 30000000

current_free = DISK_SIZE - directories[["/"]]
to_delete = NEED_FREE - current_free

puts directories
  .values
  .select{|size| size > to_delete}
  .min
