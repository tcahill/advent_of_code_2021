def parse_crab_positions(input)
  input.split(',').map(&:to_i).sort
end

def alignment_cost(alignment_position:, crab_positions:)
  crab_positions.reduce(0) do |cost, position|
    cost += (position - alignment_position).abs
  end
end

def find_best_position(crab_positions)
  (crab_positions.first..crab_positions.last).min_by do |position|
    alignment_cost(alignment_position: position, crab_positions: crab_positions)
  end
end
lines = File.readlines('input')
positions = parse_crab_positions(lines[0])
best_position = find_best_position(positions)
alignment_cost(alignment_position: best_position, crab_positions: positions)
