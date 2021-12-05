require 'set'
Struct.new('LineSegment', :point1, :point2, keyword_init: true)
Struct.new('Point', :x, :y, keyword_init: true)

def parse_line_segments(lines)
  horizontal_lines = {}
  vertical_lines = {}

  lines.each do |line|
    point1, _, point2 = line.split
    x1, y1 = point1.split(',').map(&:to_i)
    x2, y2 = point2.split(',').map(&:to_i)
    if x1 == x2
      vertical_lines[x1] ||= []
      vertical_lines[x1] << Struct::LineSegment.new(
        point1: Struct::Point.new(x: x1, y: [y1, y2].min),
        point2: Struct::Point.new(x: x1, y: [y1, y2].max),
      )
    elsif y1 == y2
      horizontal_lines[y1] ||= []
      horizontal_lines[y1] << Struct::LineSegment.new(
        point1: Struct::Point.new(x: [x1, x2].min, y: y1),
        point2: Struct::Point.new(x: [x1, x2].max, y: y1),
      )
    end
  end

  [horizontal_lines, vertical_lines]
end

def number_of_intersections(horizontal_lines, vertical_lines)
  intersecting_points = Set.new

  horizontal_lines.each do |y, lines|
    lines.each_with_index do |line, index|
      find_parallel_intersections!(line, lines[...index] + lines[index+1..], intersecting_points, :x)
      perpindicular_candidates = vertical_lines.select { |x| x.between?(line.point1.x, line.point2.x) }.values.flatten
      find_perpindicular_intersections!(line, perpindicular_candidates, intersecting_points, :x)
    end
  end

  vertical_lines.each do |x, lines|
    lines.each_with_index do |line, index|
      find_parallel_intersections!(line, lines[...index] + lines[index+1..], intersecting_points, :y)
      perpindicular_candidates = horizontal_lines.select { |y| y.between?(line.point1.y, line.point2.y) }.values.flatten
      find_perpindicular_intersections!(line, perpindicular_candidates, intersecting_points, :y)
    end
  end

  intersecting_points.length
end

def find_parallel_intersections!(segment, other_segments, intersections, axis)
  other_segments.each do |other_segment|
    if parallel_segments_intersect?(segment, other_segment, axis)
      add_parallel_intersections!(segment, other_segment, intersections, axis)
    end
  end
end

def parallel_segments_intersect?(segment1, segment2, axis)
  [segment1.point1, segment1.point2].any? do |point|
    point.send(axis).between?(segment2.point1.send(axis), segment2.point2.send(axis))
  end
end

def add_parallel_intersections!(segment1, segment2, intersections, axis)
  other_axis = [:x, :y].reject { |a| a == axis }.first
  start = [segment1.point1.send(axis), segment2.point1.send(axis)].max
  finish = [segment1.point2.send(axis), segment2.point2.send(axis)].min
  (start..finish).each do |i|
    point = Struct::Point.new
    point.send("#{other_axis}=", segment1.point1.send(other_axis))
    point.send("#{axis}=", i)
    intersections.add(point)
  end
end

def find_perpindicular_intersections!(segment, other_segments, intersections, axis)
  other_segments.each do |other_segment|
    if perpindicular_segments_intersect?(segment, other_segment)
      add_perpindicular_intersections!(segment, other_segment, intersections)
    end
  end
end

def perpindicular_segments_intersect?(segment1, segment2)
  if segment1.point1.x == segment1.point2.x
    segment1.point1.x.between?(segment2.point1.x, segment2.point2.x)
  else
    segment1.point1.y.between?(segment2.point1.y, segment2.point2.y)
  end
end

def add_perpindicular_intersections!(segment1, segment2, intersections)
  if segment1.point1.x == segment1.point2.x
    intersections.add(Struct::Point.new(x: segment1.point1.x, y: segment2.point1.y))
  else
    intersections.add(Struct::Point.new(x: segment2.point1.x, y: segment1.point1.y))
  end
end

lines = File.readlines('input')
horizontal, vertical = parse_line_segments(lines)
number_of_intersections(horizontal, vertical)
