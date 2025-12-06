class Range
  def join(other)
    raise "wat?" unless overlap?(other)
    [min, other.min].min .. [max, other.max].max
  end
end

data = File.read('input.txt')
labels = data.split("\n\n").map(&:split).first
labels.map! { eval(it.gsub(?-, '..')) }

super_labels = []

while label = labels.shift
  schmabels = labels.select {|schmabel| label.overlap? schmabel}

  if schmabels.any?
    schmabels.each { labels.delete(it) }
    label = (schmabels << label).reduce(&:join)
    labels << label and next
  end

  super_labels << label
end

p super_labels.sum(&:count)
