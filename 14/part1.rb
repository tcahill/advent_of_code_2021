def parse_rules(lines)
     rules = {}
     lines.each do |line|
       if /(?<pair>[A-Z]{2}) -> (?<inserted>[A-Z])/ =~ line
         rules[pair] = [pair[0], inserted, pair[1]]
       end
     end
     rules
   end
 
   def expand_rules(rules, original_rules)
     new_rules = {}
     rules.each do |pair, output|
       new_output = []
       output.each_with_index do |c, i|
         if i+1 == output.length
           new_output << c
           break
         end
 
         if pair_output = original_rules[c+output[i+1]]
           new_output += pair_output[...-1]
         else
           new_output << c
         end
       end
       new_rules[pair] = new_output
     end
 
     new_rules
   end
 
 def expand_sequence(sequence, rules)
   new_sequence = []
   sequence.each_char.with_index do |c, i|
     if i+1 == sequence.length
       new_sequence << c
       break
     end
     if sub = rules[c+sequence[i+1]]
       new_sequence += sub[...-1]
     else
       new_sequence << c
     end
   end
   new_sequence.join
 end
 def score(sequence)
   frequencies = sequence.each_char.to_a.tally
   frequencies.values.max - frequencies.values.min
 end

 lines = File.readlines('input')
 rules = parse_rules(lines)
 original_rules = rules.dup
 9.times do
   rules = expand_rules(rules, original_rules)
end
score(expand_sequence(lines[0].strip, rules))
