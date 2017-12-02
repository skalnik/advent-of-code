#!/usr/bin/env ruby

class Day2
  def self.run(input_file)
    table = []
    File.open(input_file).each_line do |line|
      table << line.split(/\s/).inject([]) { |row, num| row << num.to_i }
    end

    puts "Part 1: #{Day2.new(table).run(part: 1)}"
    puts "Part 2: #{Day2.new(table).run(part: 2)}"
  end

  def initialize(table)
    @table = table
  end

  def run(part:)
    @table.inject(0) do |sum, row|
      sum += part == 1 ? row_sum_1(row) : row_sum_2(row)
    end
  end

  def row_sum_1(row)
    row.max - row.min
  end

  def row_sum_2(row)
    row.each do |dividend|
      if divisor = row.detect{ |x| dividend != x && dividend % x == 0 }
        return dividend / divisor
      end
    end
  end
end

Day1.run 'input/day1.txt' if __FILE__ == $0
