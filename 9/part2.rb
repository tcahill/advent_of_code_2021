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
require 'set'

def find_low_points(map)
  low_points = []

  map.each_with_index do |line, row|
    line.each_with_index do |height, column|
      if adjacent_points(map, row, column).all? { |i, j| map[i][j] > height }
        low_points << [row, column]
      end
    end
  end

  low_points
end

def calculate_basin_sizes(map, low_points)
  low_points.map do |point|
    calculate_basin_size(map, point)
  end
end


def calculate_basin_size(map, low_point)
  basin = Set.new([low_point])
  added_points = [low_point]
  while !added_points.empty?
    new_added_points = []
    added_points.each do |point|
      adjacent_points(map, point[0], point[1]).each do |i,j|
        if map[i][j] >= map[point[0]][point[1]] && map[i][j] != 9 && !basin.include?([i,j])
          new_added_points << [i, j]
          basin.add([i,j])
        end
      end
    end
    added_points = new_added_points
  end

  basin.length
end

lines = File.readlines('simple_input')

map = parse_map(lines)
low_points = find_low_points(map)
basin_sizes = calculate_basin_sizes(map, low_points)
pp basin_sizes.sort
basin_sizes.sort[-3..].reduce(:*)
