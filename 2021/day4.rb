#!/usr/bin/env ruby

class Day4
  def self.run(input_file)
    
    puts "Part 1: #{Day4.new(input_file).part_one}"
    puts "Part 2: #{Day4.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    numbers = nil
    boards = []

    File.open(@filename) do |file|
      lines = file.readlines(chomp: true).delete_if(&:empty?)
      numbers = lines.shift.split(",").map(&:to_i)

      lines.each_slice(5) do |rows|
        boards << Board.new(rows: rows)
      end
    end

    last_number = numbers[0]
    numbers.each do |number|
      break if boards.any?(&:won?)

      last_number = number

      boards.each do |board|
        board.mark(number)
      end
    end

    winner = boards.detect(&:won?)
    winner.score * last_number
  end

  def part_two
    numbers = nil
    boards = []

    File.open(@filename) do |file|
      lines = file.readlines(chomp: true).delete_if(&:empty?)
      numbers = lines.shift.split(",").map(&:to_i)

      lines.each_slice(5) do |rows|
        boards << Board.new(rows: rows)
      end
    end

    loser, last_number = nil
    numbers.each do |number|
      break if boards.all?(&:won?)

      loser = boards.detect(&:lost?)

      last_number = number
      boards.each do |board|
        board.mark(number)
      end
    end

    last_number * loser.score
  end
end

class Board
  attr_reader :rows

  def initialize(rows:)
    @rows = []
    rows.each do |row|
      values = row.split(/\s+/).delete_if(&:empty?).map(&:to_i)
      @rows << values.map do |v|
        { value: v, marked: false }
      end
    end
  end

  def mark(value)
    @rows.each do |col|
      col.each do |cell|
        if cell[:value] == value
          cell[:marked] = true
        end
      end
    end
  end

  def won?
    row_win = @rows.detect do |col|
      col.all? { |cell| cell[:marked] }
    end
    col_win = @rows.transpose.detect do |row|
      row.all? { |cell| cell[:marked] }
    end

    row_win || col_win
  end

  def lost?
    !won?
  end

  def score
    unmarked.sum
  end

  def unmarked
    cells = @rows.flatten.select { |x| !x[:marked] }.compact
    cells.map { |x| x[:value] }
  end

  def to_s
    @rows.each do |col|
      col.each do |cell|
        print "#{cell[:value]}#{'X' if cell[:marked]} "
      end
      print "\n"
    end
  end
end

Day4.run 'input/day4.txt' if __FILE__ == $0
