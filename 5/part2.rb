def parse_line_segments(lines)
  map = {}

  lines.each do |line|
    point1, _, point2 = line.split
    x1, y1 = point1.split(',').map(&:to_i)
    x2, y2 = point2.split(',').map(&:to_i)
    if x1 == x2
      range = ([y1, y2].min..[y1, y2].max).map { |y| [x1, y] }
    elsif y1 == y2
      range = ([x1, x2].min..[x1, x2].max).map { |x|  [x, y1] }
    else
      if x1 < x2
        x_range = (x1..x2)
      else
        x_range = x1.downto(x2)
      end

      if y1 < y2
        y_range = ([y1, y2].min..[y1, y2].max)
      else
        y_range = y1.downto(y2)
      end

      range = x_range.zip(y_range).to_a
    end

    range.each do |point|
      map[point] ||= 0
      map[point] += 1
    end
  end

  map
end

lines = File.readlines('input')
map = parse_line_segments(lines)
map.select { |k, v| v > 1 }.count
