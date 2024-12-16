files = []
spaces = []

cursor = 0
File.read('input.txt').chars.each_slice(2).with_index do |(file_size, space), id|
  file_size, space = file_size.to_i, space.to_i

  files << {id: id, size: file_size, location: cursor} if file_size > 0
  spaces << {id: nil, size: space, location: cursor + file_size} if space > 0

  cursor += file_size + space
end

files.reverse_each do |file|
  spaces = spaces.sort_by{|space| space[:location]}

  free_space = spaces.find {|space|
    # Has enough room for this file
    space[:size] >= file[:size] &&
    # And is to the left of the file
    space[:location] < file[:location]
  }

  next if free_space.nil?

  new_file_location = free_space[:location]
  files_original_location = file[:location]
  file_size = file[:size]

  # Move the file to the detected free_space
  file[:location] = new_file_location


  # Is the free space bigger than our file?
  if free_space[:size] > file[:size]
    # If so, resize the space to start further to the right, and shrink it by the file size.
    free_space[:location] += file[:size]
    free_space[:size] -= file[:size]
  else
    # If not, just delete the object from the list of free space.
    spaces.delete(free_space)
  end


  # Handle the space left from moving the file.
  # I found this surprisingly difficult.
  # Needed to merge the space on the left and right of the file's old location.
  # I had to do a lot of print and step debugging to get this sorted.
  # I even lost my wedding ring somewhere in the process. True story. :(

  # Is there free space to the left of the new opening?
  left_space = spaces.find{|space| files_original_location - 1 == space[:location] + (space[:size] - 1) }

  # Create a reference to whatever space ends up being the leftmost after the ops.
  # I want it for detecting spaces to the right.
  this_space = nil

  if left_space
    # There was a space to the left.
    # Instead of creating a new space where the file was, extend this leftward space to include the file that was moved.
    left_space[:size] += file_size
    # And hold reference to it
    this_space = left_space
  else
    # The block immediately to the left of the file's old location is not space. Create new space.
    # And hold reference to it.
    this_space = {id: nil, location: files_original_location, size: file_size}
    spaces << this_space
  end

  # Is there a space directly to the right of the new free space?
  right_space = spaces.find{|space| space[:location] == files_original_location + file_size }
  if right_space
    # There is. Extend the current leftware `this_space` and delete this right_space.
    this_space[:size] += right_space[:size]
    spaces.delete(right_space)
  end
end


# Build the disk
disk = []
(files + spaces).sort_by{|blk| blk[:location]}.each do |blk|
  blk[:size].times do
    disk << blk[:id]
  end
end

# Scan the disk
val = disk.each.with_index.sum do |id, i|
  id.to_i * i
end

p val
