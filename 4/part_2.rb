def parse_board_positions(lines)
  number_to_board_positions = {}

  # assumption: each board consists of 5 lines, with an empty line between each board
  lines.each_slice(6).with_index do |board_lines, board_index|
    board_lines.each_with_index do |line, row|
      line.split(" ").each_with_index do |number, column|
        number = number.to_i
        number_to_board_positions[number] ||= {}
        number_to_board_positions[number][board_index] = [row, column]
      end
    end
  end

  number_to_board_positions
end

require 'set' 
def find_last_winner(number_of_boards, number_to_board_positions, numbers)
  board_row_sums = Array.new(number_of_boards) { Array.new(5, 0) }
  board_column_sums = Array.new(number_of_boards) { Array.new(5, 0) }

  drawn_numbers = 0
  non_winning_boards = Set.new(0...number_of_boards)
  numbers.each do |number|
    drawn_numbers += 1
    number_to_board_positions[number].each do |board, position|
      row, column = position
      board_row_sums[board][row] += 1
      board_column_sums[board][column] += 1
      if board_row_sums[board][row] == 5 || board_column_sums[board][column] == 5
        non_winning_boards.delete(board)
      end

      return [board, drawn_numbers] if non_winning_boards.empty?
    end
  end
end

def calculate_score(board, numbers_drawn)
  not_drawn = []
  board.each do |line|
    line.split(" ").each do |number|
      number = number.to_i
      if !numbers_drawn.include?(number)
        not_drawn << number
      end
    end
  end

  not_drawn.sum * numbers_drawn.last
end

lines = File.readlines('input')
numbers = lines[0].split(',').map(&:to_i)
board_positions = parse_board_positions(lines[2..])
number_of_boards = lines.length / 6
board, drawn_numbers = find_last_winner(number_of_boards, board_positions, numbers)
puts "Winning board number: #{board}"
puts "Numbers drawn: #{drawn_numbers}"
board_starting_line = 2 + 6 * board
puts "Score: #{calculate_score(lines[board_starting_line...board_starting_line+5], numbers[...drawn_numbers])}"
