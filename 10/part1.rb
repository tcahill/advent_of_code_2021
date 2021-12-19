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
lines = File.readlines('input')
  score(lines)
