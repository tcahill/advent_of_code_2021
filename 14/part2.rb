def parse_rules(lines)
  rules = {}
  lines.each do |line|
    if /(?<pair>[A-Z]{2}) -> (?<inserted>[A-Z])/ =~ line
      rules[pair] = [pair[0]+inserted, inserted+pair[1]]
    end
  end
  rules
end

def count_pairs(sequence)
  sequence.each_char.to_a.each_cons(2).reduce({}) do |counts, pair|
    counts[pair.join] ||= 0
    counts[pair.join] += 1
    counts
  end
end

def expand_pairs(pairs, rules)
  new_counts = {}
  pairs.each do |pair, count|
    rules[pair].each do |new_pair|
      new_counts[new_pair] ||= 0
      new_counts[new_pair] += count
    end
  end
  new_counts
end

def score(pairs, sequence)
  frequencies = {}
  pairs.each do |pair, count|
    frequencies[pair[0]] ||= 0
    frequencies[pair[0]] += count
  end
  frequencies[sequence[-1]] += 1
  frequencies.values.max - frequencies.values.min
end

lines = File.readlines('input')
rules = parse_rules(lines)
pairs = count_pairs(lines[0].strip)
40.times do
  pairs = expand_pairs(pairs, rules)
end
pp score(pairs, lines[0].strip)
