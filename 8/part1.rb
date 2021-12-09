require 'set'
def count_occurrences(lines)
    segment_counts = Set.new([2, 3, 4, 7])
    occurrences = 0
    lines.each do |line|
      _, output = line.split('|')
      digits = output.split(' ')
      occurrences += digits.select { |d| segment_counts.include?(d.length) }.count
    end

    occurrences
  end

lines = File.readlines('input')
count_occurrences(lines)
