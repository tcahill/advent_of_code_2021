def parse_graph(lines)
  graph = {}
  lines.each do |line|
    vertex1, vertex2 = line.strip.split('-')
    [[vertex1, vertex2], [vertex2, vertex1]].each do |v1, v2|
      graph[v1] ||= []
      graph[v1] << v2
    end
  end
  graph
end
def unique_paths(graph)
  queue = [['start']]
  count = 0
  while !queue.empty?
    path = queue.pop
    if path.last == 'end'
      #pp path
      count += 1
    else
      queue += expand_path(path, graph)
    end
  end
  count
end

def small_cave?(name)
  name =~ /[a-z]+/
end
def expand_path(path, graph)
  expanded = []
  graph[path.last].each do |cave|
    next if cave == 'start'

    unless small_cave?(cave) && path.include?(cave) && path.tally.any? { |c, count| small_cave?(c) && count > 1 }
      expanded << path + [cave]
    end
  end
  expanded
end

lines = File.readlines('input')
graph = parse_graph(lines)
puts unique_paths(graph)
