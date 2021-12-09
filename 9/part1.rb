def parse_map(lines)
  lines.map { |line| line.strip.split('').map(&:to_i) }
end

def adjacent_points(map, row, column)
  points = []
  if row > 0
    points << [row-1, column]
  end

  if column > 0
    points << [row, column-1]
  end

  if row < map.length - 1
    points << [row+1, column]
  end
  if column < map.first.length - 1
    points << [row, column+1]
  end

  points
end

def find_low_points(map)
  low_points = []

  map.each_with_index do |line, row|
    line.each_with_index do |height, column|
      if adjacent_points(map, row, column).all? { |i, j| map[i][j] > height }
        pp [row, column]
        low_points << height
      end
    end
  end

  low_points
end

def risk_level(low_points)
  low_points.sum + low_points.length
end

lines = File.readlines('input')

map = parse_map(lines)
low_points = find_low_points(map)
risk_level(low_points)
