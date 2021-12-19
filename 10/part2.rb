def score(lines)
  character_scores = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
  }
  counts = tally_corrupted_characters(lines)
  counts.reduce(0) do |sum, (char, count)|
    sum += character_scores[char] * count
  end
end

def tally_corrupted_characters(lines)
  totals = { ']' => 0, '}' => 0, '>' => 0, ')' => 0}
  lines.each do |line|
    char = corrupt_character(line)
    if char
      totals[char] += 1
    end
  end
  totals
end

def corrupt_character(line)
  stack = []
  line.each_char do |char|
    if is_opening?(char)
      stack << char
    elsif is_closing?(char)
      last_opening = stack.pop
      if !delimiters_match?(opening: last_opening, closing: char)
        return char
      end
    end
  end

  nil
end

def is_opening?(char)
  ['[', '(', '<', '{'].include?(char)
end

def is_closing?(char)
  [']', '}', '>', ')'].include?(char)
end

def delimiters_match?(opening:, closing:)
  opening_to_closing = {
    '[' => ']',
    '{' => '}',
    '<' => '>',
    '(' => ')',
  }

  opening_to_closing[opening] == closing
end
def score_incomplete_lines(lines)
  lines = filter_corrupt_lines(lines)

  character_scores = {
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4,
  }

  missing_chars = lines.map do |line|
    unmatched_opening_delimiters(line)
  end

  pp missing_chars.map { |chars| chars.reverse.join }

  scores = []
  missing_chars.each do |chars|
    score = 0
    scores << chars.reverse.reduce(0) do |total, char|
      score *= 5
      score += character_scores[char]
    end
  end

  scores.sort!
  scores[scores.length / 2]
end

def filter_corrupt_lines(lines)
  lines.select do |line|
    corrupt_character(line).nil?
  end
end

def unmatched_opening_delimiters(line)
  stack = []
  line.each_char do |char|
    if is_opening?(char)
      stack << char
    elsif is_closing?(char)
      stack.pop
    end
  end
  stack
end
lines = File.readlines('input')
puts score_incomplete_lines(lines)
