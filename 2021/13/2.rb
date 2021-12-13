    dots, directions = File.read('input.txt').split("\n\n").map{|section| section.split("\n")}

    dots.map! {|dot| dot.split(',').map(&:to_i)}

    directions.each do |direction|
      axis, amp = direction[/[xy]=\d+/].split('=')
      amp = amp.to_i

      p "Folding #{axis} at #{amp}"

      # Create the crease line
      dots.reject{|x, y| (axis == 'x' ? x : y) == amp }

      # Separate the top/left from the bottom/right
      a, b = dots.partition{|x, y| (axis == 'x' ? x : y) < amp}

      b.map! do |x, y|
        case axis
        when 'x'
          [x + 2 * (amp - x), y]
        when 'y'
          [x, y + 2 * (amp - y)]
        end
      end

      dots = (a + b).uniq
    end

    x_max = dots.max_by{|x, y| x }[0]
    y_max = dots.max_by{|x, y| y }[0]

    (0..y_max).each do |y|
      (0..x_max).each do |x|
        print dots.include?([x, y]) ? '#' : ' '
      end
      print $/
    end
