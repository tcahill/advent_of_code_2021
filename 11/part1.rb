def parse_octopuses(lines)
  lines.map do |line|
    line.strip.split('').map { |energy| [energy.to_i, :charging] }
  end
end

def next_step(grid)
  grid.each do |row|
    row.each do |octopus|
      octopus[0] += 1
      octopus[1] = :charging
    end
  end

  total_flashes = 0
  while (flashes = trigger_flashes(grid)) > 0
    total_flashes += flashes
  end
  total_flashes
end

def trigger_flashes(grid)
  flashes = 0

  grid.each_with_index do |row, row_index|
    row.each_with_index do |octopus, column_index|
      if octopus[0] > 9 && octopus[1] == :charging
        octopus[0] = 0
        octopus[1] = :flashed
        charge_neighbors(grid, row_index, column_index)
        flashes += 1
      end
    end
  end

  flashes
end

def charge_neighbors(grid, row, column)
  neighbor_positions(grid, row, column).each do |neighbor_row, neighbor_column|
    octopus = grid[neighbor_row][neighbor_column]
    octopus[0] += 1 if octopus[1] == :charging
  end
end

def neighbor_positions(grid, row, column)
  neighbors = []

  (row-1..row+1).each do |r|
    (column-1..column+1).each do |c|
      if r >= 0 && c >= 0 && r < grid.length && c < grid.first.length && !(r == row && c == column)
        neighbors << [r, c]
      end
    end
  end
  neighbors
end

lines = File.readlines('input')
grid = parse_octopuses(lines)
total_flashes = 0
100.times do
  total_flashes += next_step(grid)
end

total_flashes
