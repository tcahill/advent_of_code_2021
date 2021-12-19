def find_lowest_risk(grid)
  previous_positions = {}
  risk_from_start = {}
  risk_from_start.default = Float::INFINITY
  risk_from_start[[0,0]] = 0
  heuristic_risk_to_end = {}
  heuristic_risk_to_end.default = Float::INFINITY

  queue = [[0,0]]
  while !queue.empty?
    position = queue.pop
    if position == [grid.length-1, grid.first.length-1]
      return risk_from_start[position]
    end

    neighbors(position[0], position[1], grid).each do |neighbor|
      row, column = neighbor
      risk = risk_from_start[position] + grid[row][column]
      if risk < risk_from_start[neighbor]
        previous_positions[neighbor] = position
        risk_from_start[neighbor] = risk
        heuristic_risk_to_end[neighbor] = risk + distance_to_end(row, column, grid)
        if !queue.include?(neighbor)
          insert_index = queue.bsearch_index do |pos|
            heuristic_risk_to_end[pos] < heuristic_risk_to_end[neighbor]
          end
          queue.insert(insert_index || queue.length, neighbor)
        end
      end
    end
  end
end

def neighbors(row, column, grid)
  neighbors = []

  [[row, column-1], [row, column+1], [row-1, column], [row+1, column]].each do |r, c|
    if r >= 0 && c >= 0 && r < grid.length && c < grid.first.length
      neighbors << [r, c]
    end
  end
  neighbors
end

def distance_to_end(row, column, grid)
  x_distance = (grid.first.length - 1) - column
  y_distance = (grid.length - 1) - row
  x_distance + y_distance
end

def expand_grid(grid)
  num_rows = grid.length
  num_columns = grid.first.length

  grid.each { |row| row.push(*([0] * (num_columns * 4))) }
  grid.push(*Array.new(num_rows * 4) { Array.new(num_columns * 5, 0) })

  (0...5).each do |tile_row|
    (0...5).each do |tile_column|
      next if tile_row == 0 && tile_column == 0

      (num_rows*tile_row...num_rows*(tile_row+1)).each do |row|
        (num_columns*tile_column...num_columns*(tile_column+1)).each do |column|
          if tile_row == 0
            previous_tile = grid[row][column-num_columns]
          else
            previous_tile = grid[row-num_rows][column]
          end

          if previous_tile < 9
            grid[row][column] = previous_tile + 1
          else
            grid[row][column] = 1
          end
        end
      end
    end
  end

  grid
end

lines = File.readlines('input')
grid = lines.map { |line| line.strip.split('').map(&:to_i) }
grid = expand_grid(grid)
pp find_lowest_risk(grid)
