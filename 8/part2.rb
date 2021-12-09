require 'set'

def digit_to_segments
  {
    0 => Set.new('abcefg'.each_char),
    1 => Set.new('cf'.each_char),
    2 => Set.new('acdeg'.each_char),
    3 => Set.new('acdfg'.each_char),
    4 => Set.new('bcdf'.each_char),
    5 => Set.new('abdfg'.each_char),
    6 => Set.new('abdefg'.each_char),
    7 => Set.new('acf'.each_char),
    8 => Set.new('abcdefg'.each_char),
    9 => Set.new('abcdfg'.each_char),
  }
end

def possible_mappings(segments)
  segments.map do |digit_segments|
    [
      digit_segments,
      digit_to_segments.select { |_, segment| segment.length == digit_segments.length }.keys,
    ]
  end.to_h
end

def segments_in_common(segments1, segments2)
  ((segments1 - segments2) || (segments2 - segments1)).length
end

def filter_invalid_mappings(possible_mappings:, resolved_mapping:)
  new_possible_mappings = {}

  possible_mappings.each do |segments, possible_digits|
    digits = possible_digits.select do |digit|
      resolved_mapping.all? do |resolved_segments, resolved_digit|
        actual_digit_segments = digit_to_segments[digit]
        resolved_digit_segments = digit_to_segments[resolved_digit]

        actual_segments_in_common = segments_in_common(actual_digit_segments, resolved_digit_segments)
        mapping_segments_in_common = segments_in_common(Set.new(segments.each_char),  Set.new(resolved_segments.each_char))
        actual_segments_in_common == mapping_segments_in_common
      end
    end

    new_possible_mappings[segments] = digits
  end

  new_possible_mappings
end

def remove_resolved_mappings(possible_mappings:, resolved_mapping:)
  unresolved, resolved = possible_mappings.partition do |segments, possible_digits|
    possible_digits.length > 1
  end.map(&:to_h)

  resolved = resolved.map { |k, v| [k, v.first] }.to_h

  [unresolved, resolved_mapping.merge(resolved)]
end

def find_mapping(segments)
  possible_mappings = possible_mappings(segments)
  mapping = {}

  possible_mappings, mapping = remove_resolved_mappings(possible_mappings: possible_mappings, resolved_mapping: mapping)

  while !possible_mappings.empty?
    possible_mappings = filter_invalid_mappings(
      possible_mappings: possible_mappings,
      resolved_mapping: mapping,
    )
    possible_mappings, mapping = remove_resolved_mappings(
      possible_mappings: possible_mappings,
      resolved_mapping: mapping,
    )
  end

  mapping.map { |k, v| [Set.new(k.each_char), v] }.to_h
end
def sum_lines(lines)
  lines.reduce(0) do |sum, line|
    segments, output = line.split('|')
    mapping = find_mapping(segments.split(' '))
    output_value = 0
    output.split.each_with_index do |segments, index|
      segment_set = Set.new(segments.each_char)
      output_value += mapping[segment_set]*(10**(3-index))
    end
    sum += output_value
  end
end

lines = File.readlines('input')
sum_lines(lines)
