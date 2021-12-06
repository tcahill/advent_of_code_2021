require 'ostruct'

def parse_lanternfish(input)
  lanternfish = []

  timer_values = input.split(',').map(&:to_i)
  timer_values.tally.each do |timer, num_fish|
    lanternfish << OpenStruct.new(timer: timer, num_fish: num_fish)
  end

  lanternfish
end

def advance_simulation(lanternfish)
  reproducing = lanternfish.find { |group| group.timer == 0 }
  if reproducing
    num_reproducing = reproducing.num_fish
    lanternfish.delete(reproducing)
  end

  lanternfish.each do |group|
    group.timer -= 1
  end

  return if num_reproducing.nil?

  [6, 8].each do |timer|
    group = lanternfish.find { |group| group.timer == timer }
    if !group
      group = OpenStruct.new(timer: timer, num_fish: 0)
      lanternfish << group
    end
    group.num_fish += num_reproducing
  end
end

lines = File.readlines('input')
lanternfish = parse_lanternfish(lines[0])
80.times do
  advance_simulation(lanternfish)
end

lanternfish.reduce(0) { |sum, group| sum + group.num_fish }
