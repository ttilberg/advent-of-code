paths = File.read('input.txt').split($/).map{|line| line.split('-')}

start_paths = paths.select{|here, there| here =~ /start/}
end_paths = paths.select{|here, there| there =~ /end/}
mid_paths = paths - (start_paths + end_paths)

# Include reverse travel
paths += mid_paths.map{|here, there| [there, here]}

def explore(route, paths=[])
  route = Array(route)

  node = route.last
  return route if node == 'end'
  return route if paths.empty?

  # pp "-----------------------------------"
  # pp "Established route: #{route.join(', ')}"
  # pp "Checking '#{node}' within #{paths}."

  options = paths.select{|here, there| here == node}
  return route if options.empty?

  paths -= paths.select {|here, there| here == node} if node =~ /[a-z]+/

  options.map do |here, there|
    # pp "Exploring candidate #{[here, there]}"
    explore(route + [there], paths)
  end
end

routes = explore('start', paths)


# Man, I'm really struggly to recursively return all combinations.
# I think I need map, because if I use something like each,
# any return statements abort the search for that parent path.
# I think I'm supposed to work with the arguments differently,
# but I'm not that fluent in recursion...
#
# Using map, means that it will continue to pack values into the array as we go
# except that I'm not able to flatten it correctly...

def untangle_routes(routes, fixed_routes=[])
  routes.each do |route|
    if route&.first.is_a? Array
      fixed_routes += untangle_routes(route)
    else
      fixed_routes += [route]
    end
  end
  fixed_routes
end

routes = untangle_routes(routes)
completed_routes = routes.select{|route| route.last == 'end'}
p completed_routes.size
