require 'pry'

class Board
  attr_reader(:rows)

  def initialize
    @rows = []
  end

  def add_row(row)
    @rows << row
  end

  def final_score(number)
    unmarked_numbers.map(&:value).inject(0, &:+) * number
  end

  def unmarked_numbers
    unmarked_numbers = []
    @rows.each do |row|
      unmarked_numbers << row.select(&:unmarked?)
    end
    unmarked_numbers.flatten
  end

  def columns
    columns = {}
    @rows.each do |row|
      row.each_with_index do |value, index|
        if columns[index].nil?
          columns[index] = [value]
        else
          columns[index] << value
        end
      end
    end
    columns
  end

  def mark(number)
    @rows.each do |row|
      row = row.detect { |row_number| row_number.value == number }
      row.mark unless row.nil?
    end
  end

  def winning?
    winning_row = @rows.any? { |row| row.all?(&:marked) }
    winning_column = columns.any? { |_index, column| column.all?(&:marked) }
    winning_row || winning_column
  end

  def loosing?
    !winning?
  end
end

class RowNumber
  attr_reader(:value, :marked)

  def initialize(value)
    @value = value
    @marked = false
  end

  def unmarked?
    @marked == false
  end

  def mark
    @marked = true
  end
end

def initialize_number_and_boards(filename)
  board = Board.new
  numbers = []
  boards = []
  File.open(filename, 'r').each_line do |line|
    if line.include?(',')
      numbers = line.strip.split(',').map(&:to_i)
    elsif ['', "\n", ''].include?(line)
      board = Board.new
    else
      row = line.strip.split(' ').map { |number| RowNumber.new(number.to_i) }
      board.add_row(row)
      boards << board if board.rows.size == 5
    end
  end
  [numbers, boards]
end

def part_1
  numbers, boards = initialize_number_and_boards('part1.txt')

  numbers.each do |number|
    boards.each { |board| board.mark(number) }
    if boards.any?(&:winning?)
      winning_board = boards.detect(&:winning?)
      return winning_board.final_score(number)
    end
  end
end

def part_2
  numbers, boards = initialize_number_and_boards('part2.txt')
  
  loosing_number = 0
  worst_board = nil
  
  numbers.each do |number|
    if boards.one?(&:loosing?)
      loosing_number = number
      loosing_board = boards.detect(&:loosing?)
      worst_board = loosing_board
    end
    return worst_board.final_score(loosing_number) if boards.all?(&:winning?)

    boards.each { |board| board.mark(number) }
  end
end

pp part_2
