# The general strategy I'm using is to
# have a counter for the string as a whole:
#     NNCB => N: 2, C: 1, B: 1
# and have a counter for the transitions:
#     NN: 1, NC: 1, CB: 1
#
# For each iteration of the transition, loop through
# the transition counter, determine the new value.
#
#   NN => C
#
# All the original chars are still present,
# but NN no longer exists. It is now NC and CN.
#
# So, we add C to the "string counter"
# Remove NN from the transition counter
# Add NC and CN to the transition counter.
#
# We eventually have strings with multiple of the same transitions.
#
# The final key is to multiply these effects, accounting
# for all transitions.
#
# If we have:
#    NN: 2
# it is essentially processed 2 times:
# Both instances of NN become NC and CN.
#
# Add C to the string counter twice.
# Remove NN from the transition counter twice
# Add NC and CN to the transition counter twice
#
# Ooooh yeahhhhhhhh!

template, rules = File.read('input.txt').split("\n\n")

template = template.chars
rules = rules.split($/).map{|line| line.split(' -> ')}.to_h

rules.transform_keys!{|key| key.chars}

pair_counts = Hash.new(0)

template.each_cons(2) do |l, r|
  pair_counts[[l, r]] += 1
end

counts = Hash.new(0)

# Count the chars for the initial row, NNCB => N: 2, C: 1, B: 1
template.each {|val| counts[val] += 1}


40.times do
  # additions = Hash.new 0

  # We can't modify a hash while we iterate it, so we'll copy it,
  # make our changes, and re-assign.
  next_pair_counts = pair_counts.dup

  pair_counts.each do |(l, r), v|
    # This pair no longer appears in the set, so don't trigger it.
    next if v < 1

    # The value this pair creates
    m = rules[[l, r]]

    # The pair we just operated on will no longer exist
    # NN
    #
    # If there were two NNs, they
    # must all be accounted for, since they are
    # represented as a count in the hash `v`.
    # 
    next_pair_counts[[l, r]] -= (1 * v)
    # Instead of NN, we now have these two, `v` number of times.
    # (N(C)N)
    # So next iteration we account
    # for NC
    next_pair_counts[[l, m]] += (1 * v)
    # and CN
    next_pair_counts[[m, r]] += (1 * v)

    # Determine the additions:
    #    N N C B 
    # =>  C B H
    # => C:1, B:1, H:1
    counts[m] += (1 * v)


    # Finally, merge the original row's counts:
    # N N C B => N:2, C:1, B:1
    # with the values we just added into the string:
    #  C B H  => C:1, B:1, H:1
    # => N2, C:2, B:2, H1
  end


  # Reassign pair_counts as newly determined.
  pair_counts = next_pair_counts
end

p counts.values.max - counts.values.min
