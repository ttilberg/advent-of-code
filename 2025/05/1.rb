data = File.read('input.txt')
labels, ingredients = data.split("\n\n").map(&:split)
labels.map! { eval it.gsub(?-, '..')}
ingredients.map!(&:to_i)

p ingredients.count {|i| labels.any? {|l| l === i}}