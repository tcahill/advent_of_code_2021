require 'set'

def parse_points(lines)
  points = Set.new
  lines.each do |line|
    break if line.strip.empty?
    points.add(line.strip.split(',').map(&:to_i))
  end
  points
end

def parse_folds(lines)
  folds = []
  lines.each do |line|
    if /fold along (?<direction>[x|y])=(?<value>[0-9]+)/ =~ line
      folds << [direction, value.to_i]
    end
  end
  folds
end


def fold_horizontal(row, points)
  new_points = Set.new

  points.each do |point|
    if point[1] > row
      new_points.add([point[0], row-(point[1]-row)])
    else
      new_points.add(point)
    end
  end

  new_points
end

def fold_vertical(column, points)
  new_points = Set.new

  points.each do |point|
    if point[0] > column
      new_points.add([column-(point[0]-column), point[1]])
    else
      new_points.add(point)
    end
  end

  new_points
end
lines = File.readlines('input')
points = parse_points(lines)
folds = parse_folds(lines)
fold = folds.first      
case fold[0]
when 'x'
  points = fold_vertical(fold[1], points)
when 'y'
  points = fold_horizontal(fold[1], points)
end
points.length
